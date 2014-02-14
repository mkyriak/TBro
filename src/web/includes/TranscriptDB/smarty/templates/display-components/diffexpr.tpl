<script type="text/javascript">
    {#if isset($cart_ids)#}
        {#include file="js/diffexpr.js" instance_name=$instance_name cart_ids=$cart_ids#}
    {#else#}
        {#include file="js/diffexpr.js" instance_name=$instance_name#}
    {#/if#}
    

    $(document).ready(function() {
        new Grouplist($('#{#$instance_name#}-button-gdfx-addToCart-options'), cart, addSelectedToCart);
        $('#{#$instance_name#}-button-gdfx-addToCart-options-newcart').click(addSelectedToCart);
    });

    function addSelectedToCart() {
        var group = $(this).attr('data-value');
        var selectedItems = TableTools.fnGetInstance('{#$instance_name#}-diffexp_results').fnGetSelectedData();
        if (selectedItems.length === 0)
            return;
        if (group === '#new#')
            group = cart.addGroup();
        cart.addItem($.map(selectedItems, function(val) {
            return val.feature_id;
        }), {
            groupname: group
        });

    }

    function fnShowHide(iCol)
    {
        $('#{#$instance_name#}-diffexp_results').width("98%")
        /* Get the DataTables object again - this is not a recreation, just a get of the object */
        var oTable = $('#{#$instance_name#}-diffexp_results').dataTable();
        var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
        $('#{#$instance_name#}-columnCheckbox' + iCol).html(bVis ? '&emsp;' : '&#10003;');
        oTable.fnSetColumnVis(iCol, bVis ? false : true);
    }
    function fnNumOfEntries(numOfEntries)
    {
        /* Get the DataTables object again - this is not a recreation, just a get of the object */
        var oTable = $('#{#$instance_name#}-diffexp_results').dataTable();
        var oSettings = oTable.fnSettings();
        oSettings._iDisplayLength = numOfEntries;
        oTable.fnDraw();
    }


</script>
        
<style type="text/css">
        #{#$instance_name#}-filters tr td, #{#$instance_name#}-filters tr th {
            padding: 1px !important;
        }
        #{#$instance_name#}-filters input {
            margin: 0px !important;
        }
</style>       
        
<div id="diffexpr">
    <div class="row">
        <div class="large-12 columns panel">
            <div class="row">
                <div class="large-3 columns">
                    <h4>Experiment</h4>
                </div>
                <div class="large-3 columns">
                    <h4>Condition A</h4>
                </div>
                <div class="large-3 columns">
                    <h4>Condition B</h4>
                </div>

                <div class="large-3 columns">
                    <h4>Analysis</h4>
                </div>
            </div>
            <form id="{#$instance_name#}-diffexp_filters">
                <div class="row">
                    <div class="large-3 columns">
                        <select id="{#$instance_name#}-select-gdfx-assay" size="12"></select>
                    </div>
                    <div class="large-3 columns">
                        <select id="{#$instance_name#}-select-gdfx-conditionA" size="12"></select>
                    </div>
                    <div class="large-3 columns">
                        <select id="{#$instance_name#}-select-gdfx-conditionB" size="12"></select>
                    </div>
                    <div class="large-3 columns">
                        <select id="{#$instance_name#}-select-gdfx-analysis" size="12"></select>
                    </div>
                </div>
        </div>
    </div>

    <div class="row">
        <div class="large-6 panel" style="float:left;  width:49%">
            <div class="large-12 columns">
                <h4>Filters</h4>
            </div>


            <table id="{#$instance_name#}-filters" style="width:100%">
                {#$i=2#}
                {#foreach ['baseMean','baseMeanA','baseMeanB','foldChange','log2foldChange','pval','pvaladj'] as $filter_key#}
                    <tr>
                        <th>{#$filter_key#}</th>
                        <td>
                            <select name="filter_column[{#$i#}][type]">
                                <option value="lt">&lt;</option>
                                <option value="gt">&gt;</option>
                                <option value="leq">&lt;=</option>
                                <option value="geq">&gt;=</option>
                                <option value="eq">=</option>
                            </select>
                        </td>
                        <td>
                            <input name="filter_column[{#$i#}][value]" type="text" />
                        </td>
                    </tr>
                    {#$i=$i+1#}
                {#/foreach#}
            </table>
            <button class="right" type="button" id="{#$instance_name#}-button-gdfx-table" value="table" disabled="disabled">Apply</button>


        </div>

        <div class="large-6 query_details  panel" style="display:none; float:right; width:49%" id="{#$instance_name#}-query_details">
            <div class="large-12 columns query_details" style="display:none">
                <h4>Results Overview</h4>
            </div>
            <div id='{#$instance_name#}-swappedWarning' class='large-12 columns panel' style="display: none; color:red">
                Warning! Conditions A and B have been swapped due to their orientation in the database.
                Filters still apply to your selection but the table does not.
            </div>
            <table style="width:100%" >
                <tr>
                    <td>Condition A</td>
                    <td class='conditionA has-tooltip'></td>
                </tr>
                <tr>
                    <td>Condition B</td>
                    <td class='conditionB has-tooltip'></td>
                </tr>
                <tr>
                    <td>Analysis</td>
                    <td class='analysis has-tooltip'></td>
                </tr>
                <tr>
                    <td>Organism</td>
                    <td class='organism'></td>
                </tr>
                <tr>
                    <td>Release</td>
                    <td class='release'></td>
                </tr>
                <tr>
                    <td>Hits</td>
                    <td class='hits'></td>
                </tr>
            </table>
        </div>
    </div>
</form>

<div class="row" id="{#$instance_name#}-div-gdfxtable" style="display:none">
    <div class="large-12 column panel">
        <div class="large-12">
            <h4>Detailed Results</h4>
        </div>
        <div class="large-12" id="{#$instance_name#}-div-gdfxtable-columnselector" style="display:none">        
            <ul class="button-group even-5">
                <li><button class="small button dropdown" id="{#$instance_name#}-show-entries-dropdown" data-dropdown="{#$instance_name#}-show-entries-dropdown-options"> Show Entries </button></li>
                <li><button class="small button dropdown" data-dropdown="{#$instance_name#}-show-hide-dropdown" data-options="is_hover:true">Show Columns</button></li>
                <li><button class="small button dropdown" data-dropdown="{#$instance_name#}-select-all-none-dropdown">Select</button></li>
                <li><button class="small button dropdown" type="button" id="{#$instance_name#}-button-gdfx-addToCart" data-dropdown="{#$instance_name#}-button-gdfx-addToCart-options"> Store </button></li>
                <li><button class="small button dropdown" id="{#$instance_name#}-download-dropdown" data-dropdown="{#$instance_name#}-download-dropdown-options"> Export </button></li>
            </ul>

            <ul class="f-dropdown" id="{#$instance_name#}-show-entries-dropdown-options" data-dropdown-content>
                <li onclick="fnNumOfEntries(10);"> 10 </li> 
                <li onclick="fnNumOfEntries(20);"> 20 </li> 
                <li onclick="fnNumOfEntries(50);"> 50 </li> 
                <li onclick="fnNumOfEntries(100);"> 100 </li> 
                <li onclick="fnNumOfEntries(1000);"> 1000 </li> 
                <!--<li onclick="fnNumOfEntries(1000000);"> All (Caution!) </li>-->
            </ul>
            <ul id="{#$instance_name#}-show-hide-dropdown" class="f-dropdown" data-dropdown-content>
                <li onclick="fnShowHide(1);"><span id="columnCheckbox1" style="width: 15px; display: inline-block"/>&#10003;</span> Alias</li>
                <li onclick="fnShowHide(2);"><span id="columnCheckbox2" style="width: 15px; display: inline-block"/>&#10003;</span> baseMean</li>
                <li onclick="fnShowHide(3);"><span id="columnCheckbox3" style="width: 15px; display: inline-block"/>&emsp;</span> baseMeanA</li>
                <li onclick="fnShowHide(4);"><span id="columnCheckbox4" style="width: 15px; display: inline-block"/>&emsp;</span> baseMeanB</li>
                <li onclick="fnShowHide(5);"><span id="columnCheckbox5" style="width: 15px; display: inline-block"/>&#10003;</span> foldChange</li>
                <li onclick="fnShowHide(6);"><span id="columnCheckbox6" style="width: 15px; display: inline-block"/>&#10003;</span> log2foldChange</li>
                <li onclick="fnShowHide(7);"><span id="columnCheckbox7" style="width: 15px; display: inline-block"/>&emsp;</span> pval</li>
                <li onclick="fnShowHide(8);"><span id="columnCheckbox8" style="width: 15px;"/>&#10003;</span> pvaladj</li>
            </ul>
            <ul id="{#$instance_name#}-select-all-none-dropdown" class="f-dropdown" data-dropdown-content>
                <li onclick="TableTools.fnGetInstance('{#$instance_name#}-diffexp_results').fnSelectAll();" style="width:100%">All visible</li>
                <li onclick="TableTools.fnGetInstance('{#$instance_name#}-diffexp_results').fnSelectNone();" style="width:100%">None</li>
            </ul>
            <ul id="{#$instance_name#}-button-gdfx-addToCart-options" class="f-dropdown" data-dropdown-content>
                <li id="{#$instance_name#}-button-gdfx-addToCart-options-newcart" class="keep" data-value="#new#">new</li>
            </ul>
            <ul class="f-dropdown" id="{#$instance_name#}-download-dropdown-options" data-dropdown-content>
                <li id="{#$instance_name#}-download_csv_button" > csv </li> 

                <li id="{#$instance_name#}-addAllToNewCart" > add all to new cart </li> 
            </ul>
        </div>
        <div class="large-12" style="padding-right: 4px;">
            <table id="{#$instance_name#}-diffexp_results">
                <thead>  
                    <tr>
                        <th>Sequence ID</th>
                        <th>Alias</th>
                        <th>baseMean</th>
                        <th>baseMeanA</th>
                        <th>baseMeanB</th>
                        <th>foldChange</th>
                        <th>log2foldChange</th>
                        <th>pval</th>
                        <th>pvaladj</th>
                    </tr>
                </thead>
                <tbody></tbody>
                <tfoot></tfoot>
            </table>
        </div>
    </div>
</div>
</div>