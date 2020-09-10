'use strict'


function gregorian_to_jalali(timestamp) {
  var g_d_m, jy, jm, jd, gy2, days,gy, gm, gd;
  
  var a = new Date(timestamp * 1000);
  gy=a.getFullYear();
  gm=a.getMonth();
  gd=a.getDate();
  
  
  g_d_m = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  gy2 = (gm > 2) ? (gy + 1) : gy;
  days = 355666 + (365 * gy) + parseInt((gy2 + 3) / 4) - parseInt((gy2 + 99) / 100) + parseInt((gy2 + 399) / 400) + gd + g_d_m[gm - 1];
  jy = -1595 + (33 * parseInt(days / 12053));
  days %= 12053;
  jy += 4 * parseInt(days / 1461);
  days %= 1461;
  if (days > 365) {
    jy += parseInt((days - 1) / 365);
    days = (days - 1) % 365;
  }
  if (days < 186) {
    jm = 1 + parseInt(days / 31);
    jd = 1 + (days % 31);
  } else {
    jm = 7 + parseInt((days - 186) / 30);
    jd = 1 + ((days - 186) % 30);
  }
  return [jy, jm, jd,a.getHours(), a.getMinutes(), a.getSeconds()];
}


var websocket = new WebSocket("ws://192.168.43.4:10523/php-socket.php"); 

var displayMediaOptions = {
  video: {
    cursor: "always"
  },
  audio: false
};

async function startCapture() {
  const videoElem = document.getElementById("local_video");

  try {
    videoElem.srcObject = await navigator.mediaDevices.getDisplayMedia(displayMediaOptions);
  } catch(err) {
    console.error("Error: " + err);
  }
}

function stopCapture(evt) {
  const videoElem = document.getElementById("local_video");
  let tracks = videoElem.srcObject.getTracks();

  tracks.forEach(track => track.stop());
  videoElem.srcObject = null;
}

function webSocketInit()
{
	websocket.onopen = function(event) { 
	$j('#connectionStatus').find("b").html("متصل");
	
	//display("<div class='chat-connection-ack'>اتصال برقرار شد!</div>");		
	}
	websocket.onmessage = function(event) {
	var Data = JSON.parse(event.data);
	if (Data.message_type=="chat-box-html")
	{
		log(Data);
		if (typeof activeTopic.id === 'undefined')
		{
			notify("پیام جدید: "+Data.topicId.name);
			var oldval=$j('#'+Data.topicId.id).find("small.counter").html();
			$j('#'+Data.topicId.id).find("small.counter").html(++oldval);
		}
		else
			if(Data.topicId.id.trim() == activeTopic.id.trim())
			if (Data.userId.trim() != $j('#userId').html().trim())
				{
					display("<div class='"+Data.message_type+"'>"+Data.message+"</div>",Data.userId,Data.userName,);			
					notify(Data.message);
				}
		//به روزرسانی چت های خوانده نشده در تاپیک های دیگر
			else{
					notify("پیام جدید: "+Data+topicId.name);
					var oldval=$j('#'+Data.topicId.id).find("small.counter").html();
					$j('#'+Data.topicId.id).find("small.counter").html(++oldval);
				}
	}
	};
	
	websocket.onerror = function(event){
	$j('#connectionStatus').find("b").html("خطا");
	//display("<div class='error'>خطا به دلیل برخی مشکلات!</div>");
	
	};
	websocket.onclose = function(event){
	$j('#connectionStatus').find("b").html("قطع اتصال! اتصال مجدد...");
	//display("<div class='chat-connection-ack'>قطع اتصال! اتصال مجدد</div>");
	webSocketInit();
	//alert(event.code);
	}; 
}

function display(message,owner,username,preId="",date)
{
var msgClass;
if (message.length>0)
	{
		let randomString = '';
		userId=String($j('#userId').html());
		if (owner==userId)
			msgClass="chat-box-message";
		else
			msgClass="chat-box-message-rcvd";
				
		if (preId!="")
		{
			randomString=preId;
		}
		/*
		else
		{
			let characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
			for (let i = 0; i < 30; i++) {
			randomString += characters[Math.floor(Math.random() * (characters.length-1)) + 0];
			}
		}
		*/
		//onclick="$j.fancybox.open($j(this).html())"
		var PrDate=gregorian_to_jalali(date);
		if (owner==userId)
		{
			$j("#chat_list").append("<div ><a  style='text-decoration:none;' href='javascript:;'><span  onclick='$j.fancybox.open(\"hiiii\")' onmouseover=$j(this).find(\'b\').show(); onmouseout=$j(this).find(\'b\').hide();  id=\""+randomString+ "\" class=\""+msgClass+"\"><small>"+username+":</small><br/><p>"+message+"</p><b style='display:none;'><small onclick=(function(){deleteMessage(\""+randomString+"\");event.stopPropagation();})();>حذف</small>&nbsp;||&nbsp;<small onclick=(function(){editMessage(\""+randomString+"\");event.stopPropagation();})();>ویرایش</small>&nbsp;||&nbsp;<small  class=operation onclick=(function(){alert(\'محبوب\');event.stopPropagation();})();>محبوب</small>&nbsp;||&nbsp;<small  class=operation onclick=(function(){replyMessage(\""+randomString+"\");event.stopPropagation();})();>پاسخ</small>&nbsp;||&nbsp;<small  class=operation onclick=(function(){alert(\'باز ارسال\');event.stopPropagation();})();>باز ارسال</small></b></span></a><span class=\"invertable\" style=\"display:flex\">"+PrDate[0]+"/"+PrDate[1]+"/"+PrDate[2]+" - "+PrDate[3]+":"+PrDate[4]+"<span></div>");
			$j("#chat_list").scrollTop($j("#chat_list")[0].scrollHeight);
		}
		else
		{
			$j("#chat_list").append("<div ><a  style='text-decoration:none;' href='javascript:;'><span  onclick='$j.fancybox.open(\"hiiii\")' onmouseover=$j(this).find(\'b\').show(); onmouseout=$j(this).find(\'b\').hide();  id=\""+randomString+ "\" class=\""+msgClass+"\"><small>:"+username+"</small><br/><p>"+message+"</p><b style='display:none;'><small  class=operation onclick=(function(){alert(\'محبوب\');event.stopPropagation();})();>محبوب</small>&nbsp;||&nbsp;<small  class=operation onclick=(function(){replyMessage(\""+randomString+"\");event.stopPropagation();})();>پاسخ</small>&nbsp;||&nbsp;<small  class=operation onclick=(function(){alert(\'باز ارسال\');event.stopPropagation();})();>باز ارسال</small></b></span></a><span style=\"display:block\" class=\"invertable\">"+PrDate[0]+"/"+PrDate[1]+"/"+PrDate[2]+" - "+PrDate[3]+":"+PrDate[4]+"<span></div>");
			$j("#chat_list").scrollTop($j("#chat_list")[0].scrollHeight);
		}
	}
}

function editMessage(MessageID)
{
	$j('#chat-message').val($j('#'+MessageID).find("p").text());
	editMode=MessageID;
	$j('#sendMessage').val("ویرایش");
}

function deleteMessage(MessageID)
{
	$j.ajax({
	  url: adres+"/Tenants/MooniMsg/Modules/chatroom/functions/deleteMessage.php",
	  type: "POST",
	  data: {Pid : MessageID},
	success:function(data)
	{
		if (data)
		{
			$j('#'+MessageID).remove();
		}		
	}
	});
}

function replyMessage(MessageID)
{
	$j('#chat-message').val($j('#'+MessageID).find("p").text() + "\n-----\n");
	$j('#chat-message').focus();
	
}

function playSound(status)
{
	document.getElementById("msgRecieved").pause(); 
	document.getElementById("msgRecieved").currentTime = 0; 
	if (status=="newMessage")
		document.getElementById("msgRecieved").play();
}

function notify(message)
{
	// Let's check if the browser supports notifications
	  log(Notification);
	  if (!("Notification" in window)) {
		alert("This browser does not support desktop notification");
	  }

	  
	  // Let's check whether notification permissions have already been granted
	  else if (Notification.permission === "granted") {
		// If it's okay let's create a notification
		var notification = new Notification(message);
		playSound("newMessage");
	  }

	  // Otherwise, we need to ask the user for permission
	  else if (Notification.permission !== "denied") {
		$j.fancybox.open('<div style="text-align:center"><p>دسترسی به اعلان ها غبر فعال است.فعال شود؟</p><input type="button" value="بله" class="btn btn-primary" onclick="Notification.requestPermission().then(function (permission) { if(permission==\'granted\'){$j.fancybox.close();var notification = new Notification(\''+message+'\');playSound(\'newMessage\');}});"/><input  type="button" value="خیر" class="btn btn-secondart" onclick="$j.fancybox.close();"/></div>');
		Notification.requestPermission().then(function (permission) {
		  // If the user accepts, let's create a notification
		  if (permission === "granted") {
			var notification = new Notification(message);
			playSound("newMessage");
		  }
		});
	  }
}

let log = console.log.bind(console),
  stream,
  recorder,
  recorder_,
  counter=1,
  chunks,
  media;

/*
//gUMbtn.onclick = e => {
gUMbtn.onclick = e => {
  let mv = id('mediaVideo'),
      mediaOptions = {
        video: {
          tag: 'video',
          type: 'video/webm',
          ext: '.mp4',
          gUM: {video: true, audio: true}
        },
        audio: {
          tag: 'audio',
          type: 'audio/ogg',
          ext: '.ogg',
          gUM: {audio: true}
        }
      };
  media = mv.checked ? mediaOptions.video : mediaOptions.audio;
  navigator.mediaDevices.getUserMedia(media.gUM).then(_stream => {
    stream = _stream;
    id('gUMArea').style.display = 'none';
    id('btns').style.display = 'inherit';
    start.removeAttribute('disabled');
    recorder = new MediaRecorder(stream);
    recorder.ondataavailable = e => {
      chunks.push(e.data);
      if(recorder.state == 'inactive')  makeLink();
    };
    log('got media successfully');
  }).catch(log);
}
*/

function startMic(){
chunks=[];
recorder.start();
}

//startMic.onclick = e => {
function initMic(){
  //start.disabled = true;
  //stop.removeAttribute('disabled');
  
    
  let mediaOptions = {
        audio: {
          tag: 'audio',
          type: 'audio/ogg;codecs=opus',
          ext: '.ogg',
          gUM: {audio:true},
		  sampleSize: 24,
		  echoCancellation: true,
		  noiseSuppression: true,
		  sampleRate: 48000,
		  audioBitsPerSecond: 128000
        }
      };
	  
	media = mediaOptions.audio;  
	
	navigator.mediaDevices.getUserMedia(media.gUM).then(_stream => {
    
	$j('#micRecorder').attr('src','theme1/icons/_mic.svg');
	stream = _stream;
    //id('gUMArea').style.display = 'none';
    //id('btns').style.display = 'inherit';
    //start.removeAttribute('disabled');
    recorder = new MediaRecorder(stream);
    recorder.ondataavailable = e => {
      chunks.push(e.data);
      if(recorder.state == 'inactive') 
	  {
			let blob = new Blob(chunks, {type: media.type })
			, url = URL.createObjectURL(blob);
					  
			disply()
			$j("#chat_list").append("<div><a href='javsscript:;'><span  onclick='$j.fancybox.open($j(this).html())' id=\""+randomString+ "\" class=\"chat-box-message\">"+'<audio controls><source src="'+url+'" type="audio/mpeg"></audio>'+"</span></a></div>");
			$j("#chat_list").scrollTop($j("#chat_list")[0].scrollHeight);
  
	  };
    };
    log('got media successfully');
	}).catch(log);
}

function startCam(){
chunks=[];
recorder.start();
}

function initCam(){
	
  //start.disabled = true;
  //stop.removeAttribute('disabled');
    
  let mediaOptions = {
        video: {
          tag: 'video',
          type: 'video/webm',
          ext: '.mp4',
          gUM: {video: true, audio: true},
		  sampleSize: 24,
		  echoCancellation: true,
		  noiseSuppression: true,
		  sampleRate: 48000,
		  audioBitsPerSecond: 128000,
          videoBitsPerSecond: 2500000,	
		  mimeType: 'video/mp4; codecs="avc1.424028, mp4a.40.2"'		  
        }
      };
	  
	media = mediaOptions.video;  
	
	navigator.mediaDevices.getUserMedia(media.gUM).then(_stream => {
		
	$j('#camRecorder').attr('src','theme1/icons/_camera.svg');
    stream = _stream;
    //id('gUMArea').style.display = 'none';
    //id('btns').style.display = 'inherit';
    //start.removeAttribute('disabled');
    recorder = new MediaRecorder(stream);
	
    recorder.ondataavailable = e => {
      chunks.push(e.data);
	  
      if(recorder.state == 'inactive') displayInChat();
    };
    log('got media successfully');
	}).catch(log);
}

function stopRecording()
{
  stream.getTracks().forEach(track => track.stop());
  recorder.stop();//for firefox
}


function displayInChat(){
  
	let characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
	let randomString = '';
	for (let i = 0; i < 30; i++) {
		randomString += characters[Math.floor(Math.random() * (characters.length-1)) + 0];
	}
  let blob = new Blob(chunks, {type: media.type })
    , url = URL.createObjectURL(blob);
  
  if (media.tag=='audio')
  {
	  $j("#chat_list").append("<div><a href='javsscript:;'><span  onclick='$j.fancybox.open($j(this).html())' id=\""+randomString+ "\" class=\"chat-box-message\">"+'<audio controls><source src="'+url+'" type="audio/mpeg"></audio>'+"</span></a></div>");
	$j("#chat_list").scrollTop($j("#chat_list")[0].scrollHeight);
  }
	else
	{	
		
		$j("#chat_list").append("<div><a href='javsscript:;'><span  onclick='$j.fancybox.open($j(this).html())' id=\""+randomString+ "\" class=\"chat-box-message\">"+'<video style="width:300px;height:200px;" controls><source src="'+url+'" type="video/mp4"></video>'+"</span></a></div>");
		$j("#chat_list").scrollTop($j("#chat_list")[0].scrollHeight);
	}
}

function sendMessage(message="")
{
	if (editMode=="")
	{
		if (activeTopic.name!=undefined)
		{
			if (message=="")
				var msg = $j("#chat-message").val();
			else
				var msg = message;
			
			if (msg.length>0)
			{
				var chatId;
				$j.ajax({
				async:false,
				url: adres+"/Tenants/MooniMsg/Modules/chatroom/functions/sendMessage.php",
				type: "POST",
				data: {message : msg,parent:activeTopic.id,pName:activeTopic.name,ownerId:$j("#userId").html()},
				success:function(rdata)
				{
					rdata=JSON.parse(rdata);
					display(msg,$j("#userId").html(),$j('#userName').html(),rdata.messageId,rdata.timestamp);
					$j("#chat-message").html("");
					$j('#chat-message').val('');
					chatId=rdata;
				}
				});
				
				var messageJSON = {
				chat_id:chatId,
				chat_user: $j('#userId').html(),
				user_name: $j('#userName').html(),
				chat_message: msg,
				chat_topic: activeTopic
				};
				websocket.send(JSON.stringify(messageJSON));
			}
		}
		else
			alert("گفتگویی انتخاب نشده است");
	}
	else
	{	
		$j('#'+editMode).find("p").html($j("#chat-message").val());
		$j('#chat-message').val('');
		$j('#sendMessage').val("ارسال");
	}
}

function createNewTopic(title,ownerId,topicType)
{
	if (!title)
	{
		return false;
	}
		
	$j.ajax({
	  url: adres+"/Tenants/MooniMsg/Modules/chatroom/functions/newTopic.php",
	  type: "POST",
	  data: {title : title,owner:ownerId,type:topicType},
	success:function(data)
	{
		if (data)
		{
			
			$j('#chat_list').empty();
			display(data);
		}		
	}
	});
	
	$j.fancybox.close();
}
function handleTopic(topicId,topicName,topicType)
{
	//$j("#msgRecieved").play();
	
	//set active topic id
	activeTopic={id:String(topicId),name:String(topicName),type:topicType};
	if (topicType=="chat")
		targetContact=$j('#'+topicId).find("small.targetContactId").html();
	$j('div.chatTopic').css('background-color','#ff0bd9');
	$j('#'+topicId).find('div').css('background-color','gray');
	$j.ajax({
	  url: adres+"/Tenants/MooniMsg/Modules/chatroom/functions/handleTopic.php",
	  type: "POST",
	  data: {Tid : topicId},
	success:function(data)
	{
		if (data)
		{
			$j('#chat_list').empty();
			var messages=JSON.parse(data);
			for(var i=0;i<messages.length;i++)
				display(messages[i].content,messages[i].userId.uname,messages[i].userId.realName,messages[i].presentationId,messages[i].createDate);
		}		
	}
	});
	
}
