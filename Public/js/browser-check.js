function BrowserCheck()
{
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
	var isFF = userAgent.indexOf("Firefox") > -1;
    //判断是否Firefox浏览器	
	if (!isFF) {		
		top.location='/index.php?m=admin&c=business&a=invalid_browser'; 
	}
}//myBrowser() end
BrowserCheck();