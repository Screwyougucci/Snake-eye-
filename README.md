<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="utf-8" />
	    <meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE" />
        <title>ContentKeeper Content Filtering</title>

        <style>

        body

        {

            font-family:calibri, arial;

        }

        div#header

        {


            background: url("/blockpage/logo.png") no-repeat center;

            height: 250px;

        }

        div#block_info

        {

            font-weight:bold;

            font-size:24px;

            text-align:center;

            line-height:32px;

            -moz-box-shadow: 0px 0px 4px rgba(0,0,0,0.55);

            -webkit-box-shadow: 0px 0px 4px rgba(0,0,0,0.55);

            box-shadow: 0px 0px 4px rgba(0,0,0,0.55);

        }

        .block

        {

            background-color:#660000;
	    color: #FFF

        }

        .coach

        {

            background-color:#606062;

            color: #fff;

        }

        .authenticate

        {

            background-color:#606062;

            color: #fff;

        }       

        div#contact

        {

            font-weight:bold;

            text-align:center;

            font-size:16px;

            line-height:32px;

            -moz-box-shadow: 0px 0px 4px rgba(0,0,0,0.55);

            -webkit-box-shadow: 0px 0px 4px rgba(0,0,0,0.55);

            box-shadow: 0px 0px 4px rgba(0,0,0,0.55);

        }

        div#contact.authenticate a

        {

            color:#fff;

            text-decoration:none;

        }

        div#contact.coach a

        {

            color:#000;

            text-decoration:none;

        }       

        div#contact.block a

        {

            color:#000;

            text-decoration:none;

        }               

        div#policy, #notice, #rules

        {

            margin:20px;

        }

        #i_agree

        {

            margin-left: 20px;

        }

        #rules

        {

            width: 500px;

            height: 50px;

            overflow-y: scroll;

            resize: none;

            padding: 0;       

        }

        .policy

        {

            text-align:center;

            font-weight:bold;

        }

        .notice, .rules

        {

            border: 2px #000000 solid;

            padding: 5px;

            width: 600px;

            border-radius: 5px;

            margin-bottom: 12px;

            display: inline-block;

        }

        div#block_message

        {

            margin: 20px;

        }

        .url_info

        {

            font-weight:bold;

        }       

        .mainDiv

        {

            width:600px;

            margin:0;

            padding:0;

            background-color:#FFFFFF;

            margin-right:auto;

            margin-left:auto;

        }

        </style>

        <script>

            function onAgree()

            {
		if (RAW.match(/^https/)) {
			if (RAW.match(/ck_sni/) || RAW.match(/ck_ssl/)){
				document.coach.submit();
			} else {
				window.location.href = "http://" + URL;
			}
		} else {
			window.location.href = "http://" + URL;
		}
            }

            function rulesRead()

            {

                if (this.scrollHeight - this.scrollTop === this.clientHeight)

                {

                    document.getElementById("i_agree").disabled = false;

                }

            }

            function writeContent()

            {

                var BlockHeader = "RESTRICTED";

                var CoachHeader = "THIS IS A WARNING NOT A BLOCK PAGE";

                var AuthenticateHeader = "Authenticated by URL Filter Database";

                var BlockMessage = "You have been restricted by the district's internet filter policy.<a href='change-hyperlink-color.php' style='color: #CC0000'></a><br /><br /><span class='url_info' style='color:#606062;'>URL: &nbsp;&nbsp;</span><span id='URL'></span><br /><span class='url_info' style='color:#606062;'>URL Categories: &nbsp;&nbsp;</span><span id='URL_Cat'></span><br /><span class='url_info' style='color:#606062;'>Policy: &nbsp;&nbsp;</span><span id='WHY'></span><br /><span class='url_info' style='color:#606062;'>User: &nbsp;&nbsp;</span><span id='USER'></span><br /><span class='url_info' style='color:#606062;'>User's IP: &nbsp;&nbsp;</span><span><b>10.100.80.62</b></span><br /><span class='url_info' style='color:#606062;'>Timestamp: &nbsp;&nbsp;</span><span><b>Wed Sep 23 13:55:16 2026</b></span>";

                var CoachMessage = "<span class='url_info' style='color:#000000;'>URL: &nbsp;&nbsp;</span><span id='URL'></span><br /><span class='url_info' style='color:#000000;'>URL Categories: &nbsp;&nbsp;</span><span id='URL_Cat'></span><br /><span class='url_info' style='color:#000000;'>Policy: &nbsp;&nbsp;</span><span id='WHY'></span><br /><span class='url_info' style='color:#000000;'>User: &nbsp;&nbsp;</span><span id='USER'></span><br /><span class='url_info' style='color:#000000;'>User's IP: &nbsp;&nbsp;</span><span><b>10.100.80.62</b></span>";

                var CoachLink = "<br /><center><h3><a style='color: #000000' href='http://"+URL+"'>Click here to continue.</a></h3></center>";

		var CoachForm = "<form id='coach' name='coach' method='post' action='https://"+sHOST+"/cgi-bin/ck/auth'><input type='hidden' name='COACH1' value='"+USER+","+RAW+"'></form>";

                var AuthenticateMessage = "Your requested URL requires authentication.<a href='change-hyperlink-color.php' style='color: #CC0000'></a><br /><br /><span class='url_info' style='color:blue;'>URL: &nbsp;&nbsp;</span><span id='URL'></span><br /><span class='url_info' style='color:blue;'>URL Categories: &nbsp;&nbsp;</span><span id='URL_Cat'></span><br /><span class='url_info' style='color:blue;'>User: &nbsp;&nbsp;</span><span id='USER'></span>";

                var sPolicyBlock = "The site you have requested has been blocked because it does not comply with the filtering requirements as described by the <a href='http://www.fcc.gov/guides/childrens-internet-protection-act' style='color: #000000' target='_blank'>Children's Internet Protection Act (CIPA)</a>.";               

                var sPolicyCoach = "The site you have requested has been warned because it MAY not comply with the filtering requirements as described by the <a href='http://www.fcc.gov/guides/childrens-internet-protection-act' style='color: #000000' target='_blank'>Children's Internet Protection Act (CIPA)</a>.";

                var sPolicyAuthenticate = "The site you have requested has been blocked because it does not comply with the filtering requirements as described by the <a href='http://www.fcc.gov/guides/childrens-internet-protection-act' style='color: #000000' target='_blank'>Children's Internet Protection Act (CIPA)</a>.";

                var sBlockInfoElement = document.getElementById("block_info");

                var sBlockMsgElement = document.getElementById("block_message");

                var sContactElement = document.getElementById("contact");

                var sPolicyElement = document.getElementById("policy");

                var sPolicyClassElement = document.getElementsByClassName("policy");

		var sSubmissionElement = document.getElementById("submission");

               

                if (MOD==2)

                {

                    sPolicyClassElement[0].style.color = "#ec7229";

                    sBlockInfoElement.innerHTML = BlockHeader;

                    sBlockInfoElement.className = "block";

                    sContactElement.className = "block";

                    sBlockMsgElement.innerHTML = BlockMessage;

                    if (sPolicyElement)

                    {

                        sPolicyElement.innerHTML += sPolicyBlock;

                    }

                }

                else if(MOD==3)

                {

                    var sAcceptRulesElement = document.getElementById("accept_rules");

                    sAcceptRulesElement.style.display = "block";

                    sPolicyClassElement[0].style.color = "#000000";

                    var oToBeRead = document.getElementById("rules");

                    oToBeRead.onscroll = rulesRead;

                    sBlockInfoElement.innerHTML = CoachHeader;

                    sBlockInfoElement.className = "coach";

                    sContactElement.className = "coach";

                    sBlockMsgElement.innerHTML = CoachMessage;

		    sSubmissionElement.innerHTML = CoachForm;

                    //sBlockMsgElement.innerHTML += CoachLink;

                    if (sPolicyElement)

                    {

                        sPolicyElement.innerHTML += sPolicyCoach;

                    }

                }

                else if (MOD==4)

                {

                    sPolicyClassElement[0].style.color = "blue";

                    sBlockInfoElement.innerHTML = AuthenticateHeader;

                    sBlockInfoElement.className = "authenticate";

                    sContactElement.className = "authenticate";

                    sBlockMsgElement.innerHTML = AuthenticateMessage;

                    if (sPolicyElement)

                    {

                        sPolicyElement.innerHTML += sPolicyAuthenticate;

                    }

                }

                else

                {

                    document.getElementById("block_info").innerHTML = BlockHeader;

                    document.getElementById("block_message").innerHTML = BlockMessage ;

                    if (sPolicyElement)

                    {

                        sPolicyElement.innerHTML += sPolicyBlock;

                    }

                }

                document.getElementById("URL").innerHTML = URL;

                document.getElementById("URL").style.fontWeight = "bold";

                document.getElementById("URL_Cat").innerHTML = CAT;

                document.getElementById("URL_Cat").style.fontWeight = "bold";

                document.getElementById("WHY").innerHTML = WHY;

                document.getElementById("WHY").style.fontWeight = "bold";

                document.getElementById("USER").innerHTML = USER;

                document.getElementById("USER").style.fontWeight = "bold";

				//document.getElementById("IPA").innerHTML = IPA;

               // document.getElementById("IPA").style.fontWeight = "bold";

				document.getElementById("APPLIANCE").innerHTML = APPLIANCE;

				document.getElementById("APPLIANCE").style.fontWeight = "bold";

            }

            function replace(string,text,by)

            {

                // Replaces text with by in string

                var i = string.indexOf(text), newstr = '';

                if ((!i) || (i == -1))

                    return string;

                newstr += string.substring(0,i) + by;

                if (i+text.length < string.length)

                    newstr += replace(string.substring(i+text.length,string.length),text,by);

                return newstr;

            }

            function getParm(string,parm)

            {

                // returns value of parm from string

                var startPos = string.indexOf(parm + "=");

                if (startPos > -1)

                {

                    startPos = startPos + parm.length + 1;

                    var endPos = string.indexOf("&",startPos);

                    if (endPos == -1)

                    {

                        endPos = string.length;

                    }

                    var result = string.substring(startPos,endPos);

                    return unescape(result).replace(/[<>]/g, "");

                }

                return '';

            }

 

            var sURL = unescape(window.location.href);
	
	    var sHOST = location.host;

            var passed = location.search.substring(1);

            var URL = getParm(passed,'URL'); URL = replace(URL,"+"," ");

            var CAT = getParm(passed,'CAT'); CAT = replace(CAT,"+"," ");

            var USER = getParm(passed,'ACC'); USER = replace(USER,"+"," ");

            var WHY = getParm(passed,'WHY'); WHY = replace(WHY,"+"," ");

            var IPA = getParm(passed,'IPA'); IPA = replace(IPA,"+"," ");

            var MOD = getParm(passed,'MOD'); MOD = replace(MOD,"+"," ");

            var RAW = getParm(passed,'RAW'); RAW = replace(RAW,"+"," ");	           



            var APPLIANCE; 		

            switch(IPA){

		case "10.10.10.16":

			APPLIANCE="CK1";

			break;

		default:

			APPLIANCE="ContentKeeper";

	    }

 

            var SPACER = " ";

            var NEWLINE ="%0D%0A";

            var USERNAME = "Username: ";

            var SITE = "Site accessed: ";

            var CATEGORY = "Category: ";

             var POLICY = "Policy: ";

            var IPADD = "Users IP Address: 10.100.80.62";

            var MAIL = SITE+URL+NEWLINE+CATEGORY+CAT+NEWLINE+POLICY+WHY+NEWLINE+USERNAME+USER+NEWLINE+IPADD;

        </script>

  </head>

    <body onLoad="writeContent();">

        <div id="wrapper">

            <div class="mainDiv">

                <div id="header">       

                </div>

                <div id="block_info">

                </div>

                <div id="block_message">

                </div>

                    <center>

                        <script src='https://auth.contentkeeper.com/rand.js' type='text/javascript'></script><script>document.write('<input type="Button" value="Login" onclick="login(RAW);"</>');</script>	</center>

                <hr style="background-color:#606062;height:2px;border:none;" />

                <div id="footer">

                    <div id="policy">

                        <div class="policy">Acceptable Use Policy</div>

                    </div>

                    <div id="accept_rules" style="display:none;">

                        <div class="notice">

                            <span id="notice">To proceed, please read and acknowledge the following:</span>

                        </div>

                        <div class="rules">

                            <textarea readonly id="rules">This is a warning page, NOT A BLOCK PAGE.  If you are aware of the site content or have reviewed the site in the past, click "Continue."  This is just a warning to Teachers and Staff that this site may contain objectionable material.  Please click "Continue" to proceed.</textarea>
			
			<div id="submission">

			</div>

                            <input type="button" onClick="onAgree();" id="i_agree" value="Continue">

                        </div>

                    </div>

                    <div id="contact">

                        &nbsp; <!-- To submit this blocked site for review, -->

                        <script>

                            // document.write('<td bgcolor="#E00000" class="font"><a href="mailto:changeme@example.com?subject=URL Review&body=' + MAIL + '">click here to email support.</a></td>');

                        </script>

                    </div>

                    <br /><br /><br /><br /><br /><br />

                </div>

            </div>

        </div>

    </body>

</html>

