<div style="width:100%;text-align:justify;">
{for $i=0 to $news_mainNews_ini_data["content"]|count-1}
<p onmouseover='color=$(this).css("background-color");$(this).css("background-color","darkgrey")' onmouseout='$(this).css("background-color",color)'>
<span style="font-weight:bold"><a href='{$tenantDomain}Tenants/{$tenantName}/Modules/news/functions/details.php?id={$news_mainNews_ini_data["content"][$i]["id"]}'>{$news_mainNews_ini_data["content"][$i]["title"]}</a></span>
<br/>
{$news_mainNews_ini_data["content"][$i]["shortDescription"]}
</p>
{/for}
<small>template from local tenant</small>
</div>