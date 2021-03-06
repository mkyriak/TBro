<?php

namespace webservices\combisearch;

use \PDO as PDO;

/**
 * WebService.
 * Searches for Features which is part of the given pathway (pathway given as part of its description - ignore case)
 */
class Inpathway_term extends \WebService {

    /**
     * @param $querydata[species] organism id
     * @param $querydata[release] release name
     * @param $querydata[term] term to search for
     * @returns array of feature ids
     */
    public function execute($querydata) {
        global $db;
        $constant = 'constant';

        $species = $querydata['species'];
        $release = $querydata['release'];

        $term = sprintf('%%%s%%', trim($querydata['term']));

        $ids = array();
        $ids_query = "";
        if (isset($querydata['ids']) && count($querydata['ids']) > 0) {
            $ids = $querydata['ids'];
            $ids_query = 'AND feature.feature_id IN (' . implode(',', array_fill(0, count($ids), '?')) . ')';
        }

        $query_get_features = <<<EOF
                
  SELECT feature.feature_id FROM feature,
	(SELECT feature_id FROM feature_dbxref,
		(SELECT dbxref_id FROM cvterm,
			(SELECT object_id FROM cvterm_relationship,
				(SELECT * FROM cvterm, 
					(SELECT * from dbxref 
					WHERE db_id=(SELECT db_id FROM db WHERE name='KEGG' LIMIT 1)) AS dbx
				WHERE cvterm.dbxref_id=dbx.dbxref_id
                                AND UPPER(cvterm.definition) LIKE UPPER(?)) AS cvt
			WHERE cvterm_relationship.subject_id=cvt.cvterm_id) AS obj
		WHERE cvterm.cvterm_id=obj.object_id) AS dbxr
	WHERE feature_dbxref.dbxref_id=dbxr.dbxref_id) AS fdbx
WHERE feature.feature_id=fdbx.feature_id 
AND organism_id=?
AND type_id IN ({$constant('CV_ISOFORM')}, {$constant('CV_UNIGENE')})
AND feature.dbxref_id = (SELECT dbxref_id FROM dbxref WHERE db_id={$constant('DB_ID_IMPORTS')} AND accession=? LIMIT 1)
{$ids_query}
EOF;
        
//        $query = "SELECT name FROM feature WHERE id=?";
//        $stm = $db->prepare($query);
//        $stm->execute(array(12));

        $stm_get_features = $db->prepare($query_get_features);

        $data = array('results' => array());

        $stm_get_features->execute(array_merge(array($term, $species, $release), $ids));
        
        while ($row = $stm_get_features->fetch(PDO::FETCH_ASSOC)) {
            $data['results'][] = $row['feature_id'];
        }
        $data['results'] = array_unique($data['results']);
        
        return $data;
    }

}

?>
