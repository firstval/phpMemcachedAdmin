<div class="sub-header corner full-size padding">
    Live Stats for: 
    <?php echo Library_HTML_Components::clusterSelect('cluster_select', (isset($_GET['cluster'])) ? $_GET['cluster'] : '', 'live', 'onchange="changeCluster(this);"'); ?>
</div>

<div style="margin:15px 0">
<h2>Memcached</h2>
<canvas id="chart_memcached" width="996" height="200"></canvas>
</div>

<div class="chart-legend">
    <div class="chart-legend-item"><div class="chart-legend-dot get"></div> Get/s</div>
    <div class="chart-legend-item"><div class="chart-legend-dot set"></div> Set/s</div>
</div>

<div style="margin:15px 0">
<h2>MySQL</h2>
<canvas id="chart_mysql" width="996" height="200"></canvas>
</div>

<div class="chart-legend">
    <div class="chart-legend-item"><div class="chart-legend-dot select"></div> Select/s</div>
    <div class="chart-legend-item"><div class="chart-legend-dot insert"></div> Insert/s</div>
    <div class="chart-legend-item"><div class="chart-legend-dot update"></div> Update/s</div>
</div>

<div style="float:left;">
<?php
# Refresh rate increased
if($refresh_rate > $_ini->get('refresh_rate'))
{ ?>
    <div class="container corner" style="padding:9px;">
	Connections errors were discovered, to prevent any problem, refresh rate was increased by
	<?php echo sprintf('%.1f', $refresh_rate - $_ini->get('refresh_rate')); ?> seconds.
	</div>
	<?php
} ?>

<div class="full-size">
<pre id="stats" class="live">

Loading live stats, please wait ~<?php echo sprintf('%.0f', 5 + $refresh_rate - $_ini->get('refresh_rate')); ?> seconds ...
</pre>
</div>
<div class="container corner full-size padding">
<div class="line">
<span class="left setting">SIZE</span>
Total cache size on this server
</div>
<div class="line">
<span class="left setting">%MEM</span>
Percentage of total cache size used on this server
</div>
<div class="line">
    <span class="left setting">%HIT</span>
Global hit percent on this server : get_hits / (get_hits + get_misses)
    </div>
    <div class="line">
    <span class="left setting">TIME</span>
    Time taken to connect to the server and proceed the request, high value can indicate a latency or server problem
    </div>
    <div class="line">
    <span class="left setting">REQ/s</span>
    Total request per second (get, set, delete, incr, ...) issued to this server
    </div>
    <div class="line">
    <span class="left setting">CONN</span>
    Current connections, monitor that this number doesn't come too close to the server max connection setting
    </div>
    <div class="line">
    <span class="left setting">GET/s, SET/s, DEL/s</span>
    Get, set or delete commands per second issued to this server
    </div>
    <div class="line">
    <span class="left setting">EVI/s</span>
    Number of times an item which had an explicit expire time set had to be evicted before it expired
    </div>
    <div class="line">
    <span class="left setting">READ/s</span>
    Total number of bytes read by this server from network
    </div>
    <div class="line">
    <span class="left setting">WRITE/s</span>
    Total number of bytes sent by this server to network
    </div>
    </div>

    </div>
    <script type="text/javascript" src="Public/Scripts/smoothie.js"></script>
    <script type="text/javascript">
    var timeout = <?php echo $refresh_rate * 1000; ?>;
    var page = 'stats.php?request_command=live_stats&cluster=<?php echo $cluster; ?>';
    setTimeout("ajax(page,'stats')", <?php echo (5 + $refresh_rate - $_ini->get('refresh_rate')) * 1000; ?>);

    //Randomly add a data point every 500ms
    //var random = new TimeSeries();
    //setInterval(function() {
	//random.append(new Date().getTime(), Math.random() * 100);
    //}, 1000);

    function updateGetChart(value) {
        memcached_get.append(new Date().getTime(), value);
    }
    function updateSetChart(value) {
        memcached_set.append(new Date().getTime(), value);
    }
    function updateMysqlSelectChart(value) {
        mysql_select.append(new Date().getTime(), value);
    }
    function updateMysqlInsertChart(value) {
        mysql_insert.append(new Date().getTime(), value);
    }
    function updateMysqlUpdateChart(value) {
        mysql_update.append(new Date().getTime(), value);
    }

    memcached_get = new TimeSeries();
    memcached_set = new TimeSeries();
    mysql_select = new TimeSeries();
    mysql_insert = new TimeSeries();
    mysql_update = new TimeSeries();

    function timeline() {
        var memcached_chart = new SmoothieChart({
            millisPerPixel:87,
            maxValue: 2500,
            minValue: 0,
            grid:{
                fillStyle:'rgba(0,0,0,0.63)',
                strokeStyle:'rgba(119,119,119,0.48)',
                millisPerLine: 8000,
                verticalSections: 8,
                borderVisible: false
            },
            timestampFormatter:SmoothieChart.timeFormatter
        });
        var mysql_chart = new SmoothieChart({
            millisPerPixel:87,
            maxValue: 200,
            minValue: 0,
            grid:{
                fillStyle:'rgba(0,0,0,0.63)',
                strokeStyle:'rgba(119,119,119,0.48)',
                millisPerLine: 8000,
                verticalSections: 8,
                borderVisible: false
            },
            timestampFormatter:SmoothieChart.timeFormatter
        });
        memcached_canvas = document.getElementById('chart_memcached');
        mysql_canvas = document.getElementById('chart_mysql');

        //chart.addTimeSeries(random, {
            //strokeStyle: 'rgba(128, 255, 0, 1)',
            //fillStyle: 'rgba(128, 255, 0, 0.2)',
            //lineWidth: 4
        //});
        memcached_chart.addTimeSeries(memcached_get, {
            strokeStyle: 'rgba(0, 255, 128, 1)',
            fillStyle: 'rgba(0, 255, 128, 0.2)',
            lineWidth: 4
        });
        memcached_chart.addTimeSeries(memcached_set, {
            strokeStyle: 'rgba(255, 0, 0, 1)',
            fillStyle: 'rgba(255, 0, 0, 0.2)',
            lineWidth: 4
        });
        mysql_chart.addTimeSeries(mysql_select, {
            strokeStyle: '#013ADF',
            fillStyle: 'rgba(1, 58, 223, 0.2)',
            lineWidth: 4
        });
        mysql_chart.addTimeSeries(mysql_insert, {
            strokeStyle: '#DF0174',
            fillStyle: 'rgba(223,1,116, 0.2)',
            lineWidth: 4
        });
        mysql_chart.addTimeSeries(mysql_update, {
            strokeStyle: '#9A2EFE',
            fillStyle: 'rgba(154,46,254, 0.2)',
            lineWidth: 4
        });

        memcached_chart.streamTo(memcached_canvas, 1833);
        mysql_chart.streamTo(mysql_canvas, 1833);
    }

    timeline();
</script>
