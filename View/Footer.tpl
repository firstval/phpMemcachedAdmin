<?php
# Check for newer version
if(Library_Data_Version::check())
{ ?>
            <div class="header corner full-size padding" style="float:left; text-align:center; margin-top:10px;">
            A newer version of phpMemcachedAdmin may be available, visit <a href=""https://github.com/kevin-jones/phpMemcachedAdmin" target="_blank">Github</a> to know more.
<?php
} else { ?>
			<div class="sub-header corner full-size padding" style="float:left; text-align:center; margin-top:10px;">
                <a href="https://github.com/kevin-jones/phpMemcachedAdmin" target="_blank">phpMemcachedAdmin on Github</a> -
                <a href="http://memcached.org/" target="_blank">Memcached.org</a>
<?php
} ?>
            </div>
        </div>
    </body>
</html>
