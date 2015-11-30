<!-- custom about with baiduMap create by voitgxd -->
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak={{theme.baidu_map.app_key}}"></script>
<script type="text/javascript">
	// 百度地图API功能
	var map = new BMap.Map("map");	// 创建Map实例
	var ptBJ = new BMap.Point(116.481586, 40.018359);
	var ptSX = new BMap.Point(111.143287, 38.460809);
	var ptCC = new BMap.Point(125.295998, 43.860455);
	map.centerAndZoom(ptBJ, 3);  // 初始化地图,设置中心点坐标和地图级别
	map.enableScrollWheelZoom(true);	//开启鼠标滚轮缩放
	
	//自我展示
	function selfShow(){
		setTimeout(function(){
			map.setZoom(5);   
		}, 2000);
		setTimeout(function(){
			map.setZoom(10);   
		}, 4000);
		setTimeout(function(){
			map.setZoom(20); 
			map.openInfoWindow(infoWindow1, ptBJ); //开启信息窗口
			document.getElementById('myImg').onload = function (){
				infoWindow1.redraw();   //防止在网速较慢，图片未加载时，生成的信息框高度比图片的总高度小，导致图片部分被隐藏
			}
		}, 6000);
		setTimeout(function(){
			map.setZoom(10);
			marker.hide();
			infoWindow1.hide();
			map.centerAndZoom(ptSX, 5);
			map.enableScrollWheelZoom(true);
			marker2.show();
		}, 8000);
		setTimeout(function(){
			map.setZoom(10);
			map.openInfoWindow(infoWindow2, ptSX);
			document.getElementById('homeImg').onload = function (){
				infoWindow2.redraw();
			}
		}, 10000);
		setTimeout(function(){
			marker2.hide();
			infoWindow2.hide();
			map.centerAndZoom(ptCC, 5);
			map.enableScrollWheelZoom(true);
			marker3.show();  
		}, 12000);
		setTimeout(function(){
			map.setZoom(15);
		}, 14000);
		setTimeout(function(){
			map.setZoom(20);
			map.openInfoWindow(infoWindow3, ptCC);
			document.getElementById('universityImg').onload = function (){
				infoWindow3.redraw();
			} 
		}, 16000);
		setTimeout(function(){
			marker3.hide();
			infoWindow3.hide();
			map.centerAndZoom(ptBJ, 15);
			map.enableScrollWheelZoom(true);
			marker.show();
			marker.addEventListener("click", function(){          
				selfShow();
			});
		}, 18000);
	}
	//创建人物1
	var myIcon = new BMap.Icon("http://developer.baidu.com/map/jsdemo/img/fox.gif", new BMap.Size(300,157));
	var marker = new BMap.Marker(ptBJ, {icon:myIcon});
	map.addOverlay(marker);
	var sContent =
	"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>VOIT GXD:</h4>" + 
	"<img style='float:right;margin:4px' id='myImg' src='http://7xnq6l.com1.z0.glb.clouddn.com/voitgxd.jpg' width='105' height='104' title='me'/>" + 
	"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>I am here now! Coding for huobaoyx.</p>" + 
	"</div>";
	var infoWindow1 = new BMap.InfoWindow(sContent);  // 创建信息窗口对象 
	
	//创建人物2
	var marker2 = new BMap.Marker(ptSX, {icon:myIcon});
	map.addOverlay(marker2);
	var sContent2 =
	"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>HOMETOWN:</h4>" + 
	"<img style='float:right;margin:4px' id='homeImg' src='http://7xnq6l.com1.z0.glb.clouddn.com/voitgxd.jpg' width='105' height='104' title='me'/>" + 
	"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>山西省吕梁市</p>" + 
	"</div>";
	var infoWindow2 = new BMap.InfoWindow(sContent2);
	marker2.hide();
	
	//创建人物3
	var marker3 = new BMap.Marker(ptCC, {icon:myIcon});
	map.addOverlay(marker3);
	var sContent3 =
	"<h4 style='margin:0 0 5px 0;padding:0.2em 0'>UNIVERSITY:</h4>" + 
	"<img style='float:right;margin:4px' id='universityImg' src='http://7xnq6l.com1.z0.glb.clouddn.com/voitgxd.jpg' width='105' height='104' title='me'/>" + 
	"<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>长春工业大学,学习经历...</p>" + 
	"</div>";
	var infoWindow3 = new BMap.InfoWindow(sContent3);
	marker3.hide();
	
	selfShow();
</script>
