<!DOCTYPE html>
<html lang="en">
	<head>
		<title>PIK - پیام رسان کسب و کاری</title>
		<base href="{$urlPatch}"/>
		<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">
				<link rel="stylesheet" href="theme1/styles/bootstrap.min.css">
					<link rel="stylesheet" href="{$urlPatch}/styles/fonts.css">
						<link rel="stylesheet" href="{$urlPatch}/styles/main.css">
							<link rel="stylesheet" href="{$urlPatch}/styles/jquery.fancybox.min.css">

								<script src="theme1/js/jquery.min.js"></script>
								<!--
							<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
							-->
								<script src="theme1/js/bootstrap.min.js"></script>
								<script src="{$urlPatch}/js/jquery.fancybox.min.js"></script>
								<script>var $j = jQuery.noConflict(true);</script>
								<!--for video and audio message -->
								<script src="{$urlPatch}/js/script.js"></script>
								<script src="{$urlPatch}/js/adapter.js"></script>
								<script src="{$urlPatch}/js/chatclient.js"></script>
								<script>  
									
									//global variables
									var adres="{$tenantDomain}";
									var uid="{$tenantDomain}";
									var activeTopic= new Object();
									var targetContact= "";
									var lastSeen=0;
									var editMode="";
									var shareScreen=false;
									
									
									/*function display(messageHTML) {
									$('#chat-box').append(messageHTML);
									}*/

									$j(document).ready(function(){
									
									
									webSocketInit();
									connect();
									
									});

								</script>
										
								

									</head>
									<body style="background-color:black;background-image:url({$urlPatch}/pics/sky.jpg);font-family:BNazanin" onbeforeunload='' onmousemove="lastSeen=Date.now() /1000 |0;" >

										<div class="container " style="direction:rtl;">

											<div class="row rounded">
												<a href="javascript:;" data-fancybox data-src="#settings" style="text-decoration:none">
													<div class="col" style="direction:rtl;text-align:right">
														<img src="{$urlPatch}/icons/profile.svg"/>
														{if $content == ""}
														<span>خوش آمدی کاربر مهمان! در صورتیکه قبلا ثبت نام کرده اید <b><a href="javascript:;">وارد</a></b> شوید</span>
														{else}
														خوش آمدید <span id="userName">{$content["uname"]}</span>
														<span id="userId" style="display:none">{$content["uid"]}</span>
														{/if}
														
														{if $content != ""}
														<div style="display:none; direction:rtl;text-align:right" id="settings">

															<div style="text-align:center"><img src="{$urlPatch}/icons/profile.svg"/></div>
															<div><img src="{$urlPatch}/icons/account.svg"/><a href="javascript:;" style="text-decoration:none"><b>اطلاعات حساب کاربری</b></a></div>
															<div><img src="{$urlPatch}/icons/chat.svg"/>گفتگوها</div>
															<div><img src="{$urlPatch}/icons/notification.svg"/>اعلان ها</div>
															<div><img src="{$urlPatch}/icons/cloud-storage.svg"/>اطلاعات و ذخیره سازی</div>
															<div><img src="{$urlPatch}/icons/help.svg"/>راهنما</div>

															<div style="text-align:center"><span style="position:relative;top:30px;">محصولی از </span><br/><br/><img src="{$urlPatch}/pics/ITaaS.jpg" style="height:128px;width:180px"/></div>
														</div>
														{else}
														<div style="display:none; direction:rtl;text-align:right" id="settings">

															<div style="text-align:center"><img src="{$urlPatch}/icons/profile.svg"/></div>
															<p>برای مشاهده تنظیمات حساب کاربری وارد سیستم شوید</p>
															<div><img src="{$urlPatch}/icons/help.svg"/> راهنما </div>

															<div style="text-align:center"><span style="position:relative;top:30px;">محصولی از </span><br/><br/><img src="{$urlPatch}/pics/ITaaS.jpg" style="height:128px;width:180px"/></div>
														</div>
														{/if}

													</div>
													</a>
													
													<span style="font-weight:bold" class="invertable">حالت شب<input type="checkbox" onclick={literal}'if($j(this).is(":checked")==true){$j(body).css("background-image","none"),$j(".invertable").css("filter","invert(1)")} else{$j(body).css("background-image","url(\"{/literal}{$urlPatch}{literal}/pics/sky.jpg\")"),$j(".invertable").css("filter","invert(0)")}'>{/literal}</span>

											</div>


											<div class="row">

												<div class="col border rounded" style="direction:rtl;text-align:right">




													<div class="col">
														<input type="text" class="form-control w-100" placeholder="جستجو..."/>
													</div>

												</div>

												<div class="col border rounded" style="direction:rtl;text-align:right" >


													<img src="{$urlPatch}/icons/lock.svg"/ title="قفل کردن صفحه" onclick='{literal}$j.fancybox.open("<span style=\"direction:rtl\">صفحه قفل شد</span>",{scrolling: "no",modal:true,padding: 0,     closeEffect: "elastic"});{/literal}' class="invertable">
													<img src="{$urlPatch}/icons/people.svg" title="مشاهده کاربران " class="invertable"/>
													<img src="{$urlPatch}/icons/trash.svg" title="حذف کردن گفتگو" class="invertable"/>
													<img src="{$urlPatch}/icons/add-person.svg" title="افزودن نفر جدید" class="invertable"/>
													<a href="javascript:;"><img id="call" src="{$urlPatch}/icons/voiceCall.svg" title="مکالمه صوتی" class="icons invertable" onclick="voiceCallInit();invite();"  /></a>
													<a id="vcall" href="javascript:;">
														<img src="theme1/icons/videoCall.svg" title="مکالمه تصویری" class="icons invertable" onclick="videoCallInit();invite();"/>
													</a>
													<a id="scsharing" href="javascript:;">
														<img src="theme1/icons/screenSharing.svg" title="اشتراک صفحه" class="icons invertable" onclick="shareScreen=true;videoCallInit();invite();"/>
													</a>
													<a id="webinar" href="javascript:;" style="display:none">
														<img src="theme1/icons/webinar.svg" title="وبینار" class="invertable" />
													</a>
													<a id="videoConference" href="javascript:;" style="display:none">
														<img src="theme1/icons/videoConference.svg" title="ویدئو کنفرانس" class="invertable" />
													</a>

													<div id="logout-content" style="display:none">
														<p>آیا قصد خارج شدن از حساب کاربری خود را دارید؟</p>
														<input type="button" value="خیر" class="btn btn-secondart" onclick="$j.fancybox.close();"/>
														<input type="button" value="بله" class="btn btn-primary"/>
													</div>

													{if $content != ""}
													<a data-fancybox data-src="#logout-content" href="javascript:;"><svg class="bi bi-power" width="2em" height="2em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
															<path fill-rule="evenodd" d="M5.578 4.437a5 5 0 104.922.044l.5-.866a6 6 0 11-5.908-.053l.486.875z" clip-rule="evenodd"/>
															<path fill-rule="evenodd" d="M7.5 8V1h1v7h-1z" clip-rule="evenodd"/>
														</svg></a>
													{else}
													<a href="javascript:window.top.close();" ><svg class="bi bi-power" width="2em" height="2em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
															<path fill-rule="evenodd" d="M5.578 4.437a5 5 0 104.922.044l.5-.866a6 6 0 11-5.908-.053l.486.875z" clip-rule="evenodd"/>
															<path fill-rule="evenodd" d="M7.5 8V1h1v7h-1z" clip-rule="evenodd"/>
														</svg></a>
													{/if}	
													<span class="invertable" id="connectionStatus">وضعیت اتصال به سرور : <b>قطع اتصال! اتصال مجدد...</b></span>
												</div>
											</div>
											
											<div id="newTopicBox" style="display:none;direction:rtl;text-align:right">
												<input id="newTopicName" type="text" class="form-control" />
												<div style="text-align:center">
												<br/>
												{if $content != ""}
												<input type="button" value="ایجاد" class="btn btn-primary" onclick='createNewTopic($j("#newTopicName").val(),{$content["uid"]},$j(".active").attr("data-type"));'/>
												{else}
												{/if}
												</div>
											</div>
											
											<div class="row">
												<div class="col border rounded  overflow-auto" style="height:80vh;" >

													
													
													<a  href="javascript:;" id="newTopic" style="text-decoration:none;color:black;"><div style="left: 5px;bottom: 0px;position: absolute;background-color: red;border-radius: 50%;width: 50px;height:50px; text-align: center;font-weight: bold;font-size: 30px;" {literal}onclick="$j.fancybox.open({src  : '#newTopicBox',	type : 'inline',opts : {		beforeShow : function( instance, current ) {$j('#newTopicName').val('');$j('#newTopicName').attr('placeholder',$j('.active').attr('data-msg'));}}});{/literal}">+</div></a>
													
													<ul class="nav nav-pills nav-fill">
														
														<li class="nav-item">
															<a class="nav-link active" href="javascript:;" data-msg="عنوان گفتگوی جدید"  data-type="chat" onclick='$j("#newTopic").show();$j(".contentHolder").hide();$j("#chats").show();$j(".nav-link").removeClass("active");$j(this).addClass("active");$j("#videoConference,#webinar").hide();$j("#call,#vcall,#scsharing").show();'>گفتگو</a>
														</li>
														<li class="nav-item">
															<a class="nav-link" href="javascript:;" data-msg="عنوان گروه جدید" data-type="group"  onclick='$j("#newTopic,#videoConference").show();$j(".contentHolder").hide();$j("#groups").show();$j(".nav-link").removeClass("active");$j(this).addClass("active");$j("#call,#vcall,#scsharing,#webinar").hide();'>گروه</a>
														</li>
														<li class="nav-item">
															<a class="nav-link" href="javascript:;" data-msg="عنوان کانال جدید" data-type="channel" onclick='$j("#newTopic,#webinar").show();$j(".contentHolder").hide();$j("#channels").show();$j(".nav-link").removeClass("active");$j(this).addClass("active");$j("#call,#vcall,#scsharing,#videoConference").hide();'>کانال</a>
														</li>
														<li class="nav-item">
															<a class="nav-link" href="javascript:;" onclick='$j("#newTopic").hide();$j(".contentHolder").hide();$j("#services").show();$j(".nav-link").removeClass("active");$j(this).addClass("active");$j("#call,#vcall,#scsharing").hide();'>خدمات</a>
														</li>
													</ul>

													<div id="chats" class="contentHolder" style="direction:rtl;text-align:right">

													{if $content == ""}
													<br/>
													<span style="text-align:right">متاسفانه شما گفتگویی با دیگران ندارید</span>
													{else}
													{for $i=0 to count($content["ugroups"])-1}
													{if $content["ugroups"][$i]["type"]=="chat"}
													<a href="javascript:;"   id ='{$content["ugroups"][$i]["topicId"]}' onclick='handleTopic({$content["ugroups"][$i]["topicId"]},"{$content["ugroups"][$i]["name"]}","{$content["ugroups"][$i]["type"]}")'><div class="chatTopic" style="direction:rtl;text-align:right;background-color:#ff0bd9;height:50px;margin-bottom:2px;">
																		<img src="theme1/icons/home.svg"/>		
																			{$content["ugroups"][$i]["name"]}<small>({count($content["ugroups"][$i]["members"])}عضو)</small>
													
													<small class="counter">0</small>
													{for $j=0 to count($content["ugroups"][$i]["members"])-1}
													{if $content["ugroups"][$i]["members"][$j]["uid"] != {$content["uid"]}}
													<small style="display:none" class="targetContactId">{$content["ugroups"][$i]["members"][$j]["uid"]}</small>
													{/if}
													{/for}
													</div></a>
													{/if}
													{/for}
													{/if}

													</div>

													<div id="groups" style="display:none;direction:rtl;text-align:right" class="contentHolder">
													
													{if $content == ""}
													<br/>
													<span style="text-align:right">در حال حاضر شما عضو هیچ گروهی نیستید!</span>
													{else}
													{for $i=0 to count($content["ugroups"])-1}
													{if $content["ugroups"][$i]["type"]=="group"}
													<a href="javascript:;" ><div style="direction:rtl;text-align:right;background-color:#eaf54a;height:50px;margin-bottom:2px;">
																		<img src="theme1/icons/home.svg"/>		
																			{$content["ugroups"][$i]["name"]}<small>({count($content["ugroups"][$i]["members"])}عضو)</small>
													
													<span class="topicId" style="display:none">{$content["ugroups"][$i]["topicId"]}</span>
													</div></a>
													{/if}
													{/for}
													{/if}

													</div>

													<div id="channels" style="display:none;direction:rtl;text-align:right" class="contentHolder">
													
													{if $content == ""}
													<br/>
													<span style="text-align:right">هیچ کانالی شما عضو نشده اید!</span>
													{else}
													{for $i=0 to count($content["ugroups"])-1}
													{if $content["ugroups"][$i]["type"]=="channel"}
													<a href="javascript:;"><div style="direction:rtl;text-align:right;background-color:#a8ff80;height:50px;margin-bottom:2px;">
																		<img src="theme1/icons/home.svg"/>		
																			{$content["ugroups"][$i]["name"]}<small>({count($content["ugroups"][$i]["members"])}عضو)</small>
													
													<span class="topicId" style="display:none">{$content["ugroups"][$i]["topicId"]}</span>
													</div></a>
													{/if}
													{/for}
													{/if}

													</div>
													
													<div id="services" style="display:none;direction:rtl;text-align:right" class="contentHolder">
																										
													<div style="background-color:lime;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">سلامت</div>
													<div style="background-color:red;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">ورزش</div>
													<div style="background-color:yellow;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">فیلم و موسیقی</div>
													<div style="background-color:brown;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">امور بانکی</div>
													<div style="background-color:orange;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">امور خیریه</div>
													<div style="background-color:cyan;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">امور اداری</div>
													<div style="background-color:magenta;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">خرید و فروش کالا</div>
													<div style="background-color:green;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">بیمه</div>
													<div style="background-color:blue ;width:160px;height:75px;float:right;text-align:center;vertical-align:middle;font-size:20px;padding-top:20px;">آموزش</div>
													
													</div>

												</div>
												<div class="col border rounded overflow-auto"  style="height:80vh;">

													<div class="col" id="chat_list" style="height:65vh;overflow:auto">


														</div> <!--chat list-->

														<div class="row border rounded " style="position:absolute;bottom:40px;width:100%">

															<div class="col-sm-8">

																<textarea class="form-control" id="chat-message" rows="1" placeholder="پیام..."id="chat-message" ></textarea>
															</div>
															<div class="col-sm-4" style="padding-right:0px;margin-top:10px">

																<div style="display:none;text-align:right;direction:rtl" id="emojiBox">

																	<ul class="nav nav-pills nav-fill">

																		<li class="nav-item">
																			<a class="nav-link active" id="emojiItem1" href="javascript:;" onclick='$j(".Holder").hide();$j("#emoji").show();$j("#emojiItem2,#emojiItem3").removeClass("active");$j(this).addClass("active")'>شکلک</a>
																		</li>
																		<li class="nav-item">
																			<a id="emojiItem2" class="nav-link" href="javascript:;" onclick='$j(".Holder").hide();$j("#gifs").show();$j("#emojiItem1,#emojiItem3").removeClass("active");$j(this).addClass("active")'>تصویر متحرک</a>
																		</li>
																		<li class="nav-item">
																			<a id="emojiItem3" class="nav-link" href="javascript:;" onclick='$j(".Holder").hide();$j("#shortVideos").show();$j("#emojiItem1,#emojiItem2").removeClass("active");$j(this).addClass("active")'>ویدئو کوتاه</a>
																		</li>
																		

																	</ul>
																	<br/>
																	<div class="Holder" id="emoji" >
																		{include file="./smilies.tpl"}
																	</div>
																	<div class="Holder" id="gifs" style="display:none">
																		<img src="theme1/gifs/2.gif"/>
																	</div>
																	<div class="Holder" id="shortVideos" style="display:none">
																		<video width="200" height="160" autoplay loop>
																		<source src="theme1/videos/4_5773654635420059321.mp4" type="video/mp4">
																		</video>
																		<video width="200" height="160" autoplay loop>
																		<source src="theme1/videos/4_5823226486525528093.mp4" type="video/mp4">
																		</video>
																	</div>



																</div>
																<a href="javascript:;" data-fancybox data-src="#emojiBox"><img class="invertable" src="theme1/icons/smiely.svg"/></a>
																<input id ="sendMessage" type="button" value="ارسال" class="btn btn-primary" onclick="sendMessage()"/>
																
																{literal}
																<a href="javascript:;" onclick="if( $j('#micRecorder').attr('src')=='theme1/icons/mic.svg') {initMic();} else if ($j('#micRecorder').attr('src')=='theme1/icons/_mic.svg') {$j('#micRecorder').attr('src','theme1/icons/record.svg');startMic();} else {stopRecording();$j('#micRecorder').attr('src','theme1/icons/mic.svg');}"><img class="invertable" id="micRecorder" src="theme1/icons/mic.svg" style="width:32px;height:32px"/></a>
																<a href="javascript:;" onclick="if( $j('#camRecorder').attr('src')=='theme1/icons/camera.svg') initCam(); else if ($j('#camRecorder').attr('src')=='theme1/icons/_camera.svg') {$j('#camRecorder').attr('src','theme1/icons/record.svg');startCam();} else {stopRecording();$j('#camRecorder').attr('src','theme1/icons/camera.svg');}"><img class="invertable" id="camRecorder" src="theme1/icons/camera.svg" style="width:32px;height:32px"/></a>
																{/literal}	
															</div>


														</div>
														<div class="row" style="position:absolute;bottom:0px;width:100%">


															<div style="display:none;direction:rtl;text-align:right" id="moduleMarket">


																<p>هزینه ها بر اساس ریال می باشد</p>
															</div>


															<!--Plus-->
															<a href="javascript:;" data-fancybox data-src="#moduleMarket" data-toggle="tooltip" data-placement="auto" title="فروشگاه ماژول">
																<svg  class="bi bi-plus" width="2em" height="2em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
																	<path fill-rule="evenodd" d="M8 3.5a.5.5 0 01.5.5v4a.5.5 0 01-.5.5H4a.5.5 0 010-1h3.5V4a.5.5 0 01.5-.5z" clip-rule="evenodd"/>
																	<path fill-rule="evenodd" d="M7.5 8a.5.5 0 01.5-.5h4a.5.5 0 010 1H8.5V12a.5.5 0 01-1 0V8z" clip-rule="evenodd"/>
																</svg>
															</a>
															
															<!---->
															<a href="javascript:;"><img src="{$urlPatch}/icons/process.svg" style="position:absolute;left:0px;"/></a>
															<!---->

														</div>

													</div>

												</div>
											</div>
											<div class="row">
												<div class="col text-center invertable">
													کلیه حقوق محفوظ است
												</div>
											</div>
											<!-- for video and voice call -->
											<video id="received_video" autoplay style="display:none"></video>
											<video id="local_video" autoplay muted style="display:none"></video>
											<button id="hangup-button" onclick="hangUpCall();" role="button" style="display:none">
												قطع تماس
											</button>
											<audio id="msgRecieved">
												<source src="{$urlPatch}/sounds/beep.mp3" type='audio/mp3; codecs="mp3"'>
											</audio>
										</body>
									</html>