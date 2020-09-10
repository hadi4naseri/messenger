<div style="color:black;">

{*
content["data"]
content["template"]
content["addons"]
*}



<h2>{$content["data"]["title"]}</h2>

<h3>{$content["data"]["shortDescription"]}</h3>

<h4>{$content["data"]["longDescription"]}</h4>

<br/>
{if $content["data"]["addons"]}
{for $k=0 to count($content["data"]["addons"])-1}
	{include file=loadTemplate($content["data"]["addons"][$k]["moduleName"],$content["data"]["addons"][$k]["handle"],$content["addons"][$content["data"]["addons"][$k]["handle"]]["template"],NULL)}
{/for}
{/if}

</div>
