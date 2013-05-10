<?php

namespace webservices\details;

use \PDO as PDO;

class Statistical_Information extends \WebService {

    public function execute($querydata) {
        global $db;
        
        $organism = $querydata['query1'];
        $release = $querydata['query2'];


#UI hint
        if (false)
            $db = new PDO();

        $query_get_stats = <<<EOF
SELECT *
FROM materialized_view_statistical_information
WHERE
   organism = ?
   AND release=?
EOF;

        $stm_get_stats = $db->prepare($query_get_stats);

        $data = array('results' => array());

        $stm_get_stats->execute(array($organism, $release));
        while ($row = $stm_get_stats->fetch(PDO::FETCH_ASSOC)) {
            $data['results'] = $row;
        }

        return $data;
    }

}

?>
