<div style="text-align:center">
{if !isset($smarty.cookies.userTocken)}
<span>برای ورود به سیستم اطلاعات زیر را تکمیل نمائید :</span><br/><br/>
{$login_forms_f1_ini_data["form"]}
{else}
{if validateTocken($tenantName,$smarty.cookies.userTocken)}
<span><b>{$userName}</b>، شما به سیستم وارد شده اید...</span><br/><br/>
<span><a class="general fancybox fancybox.ajax" style="color:black;text-decoration:black" href="javascript:;">مرکز کنترل سیستم</a></span><br/><br/>
<span><a href="javascript:;" style="color:red;text-decoration:red">خروج از سیستم</a></span>
{else}
<span style="color:red;font-size:12px;">متاسفانه cookie ایجاد شده بر روی سیستم شما نامعتبر است.برای ادامه آن را پاک کرده و صفحه را مجددا بارگزاری نمائید</span>
{/if}
{/if}
</div>