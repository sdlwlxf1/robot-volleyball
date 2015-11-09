package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import assets.Assets;
	import assets.Particles;
	import unit4399.events.SaveEvent;
	import unit4399.events.RankListEvent;
	
	[SWF(width="800", height="500", frameRate="60", backgroundColor="#030303")]
	
	
	
	/**
	 * @author Aymeric
	 */
	public class Main extends MovieClip
	{
		
		//======1.此代码为积分排行功能专用代码========/
		public static var _4399_function_score_id:String="d8c8d4731a33a0a581edc746e73eadc7200";

		
		//======此代码为多排行榜功能专用代码========/
		public static var _4399_function_rankList_id:String = '69f52ab6eb1061853a761ee8c26324ae';
		
				//======此代码为存档功能专用代码========/
		public static var _4399_function_store_id:String = '3885799f65acec467d97b4923caebaae';
		
		
		public static var _4399_function_gameList_id:String = "944c23f5e64a80647f8d0f3435f5c7a8";

		 
		//======此代码为api通用代码，在所有api里面只需加一次========/
		public static var serviceHold:* = null;
		public function setHold(hold:*):void
		{
			serviceHold = hold;
		}

		
		
		private var gameEngine:GameEngine;
		private var logo:MovieClip;
		
		public static var debugTextField:TextField;
		public static var rttTxt:TextField;
		
		
		public static var tmpObj:Object;

		public function Main()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			//stage.align = StageAlign.TOP;
			//stage.scaleMode = StageScaleMode.NO_SCALE;

			//stage.frameRate = 20;
			
			/*logo = new Particles.LOGO();
			logo.x = 20;
			logo.y = 40;
			addChild(logo);
			logo.play();
			
			
			setTimeout(logoEnd, 15000);*/
			
			gameEngine = new GameEngine();
			
			logoEnd();
			
			/*stage.addEventListener(RankListEvent.RANKLIST_ERROR,onRankListErrorHandler);
			stage.addEventListener(RankListEvent.RANKLIST_SUCCESS,onRankListSuccessHandler);
			
			stage.addEventListener(SaveEvent.SAVE_GET,saveProcess);
			stage.addEventListener(SaveEvent.SAVE_SET,saveProcess);
			stage.addEventListener(SaveEvent.SAVE_LIST, saveProcess);
			
			
			//调用4399存档界面，进行存档时，返回的档索引
			stage.addEventListener("saveBackIndex",saveProcess);
			//网络存档失败
			stage.addEventListener("netSaveError", netSaveErrorHandler, false, 0, true);
			//网络取档失败
			stage.addEventListener("netGetError", netGetErrorHandler, false, 0, true);
			//游戏防多开
			stage.addEventListener("multipleError", multipleErrorHandler, false, 0, true);
			//调用获取游戏是否多开的状态接口时，返回状态值
			stage.addEventListener("StoreStateEvent", getStoreStateHandler, false, 0, true);
			//调用读档接口且该档被封时，则会触发该事件
			stage.addEventListener("getDataExcep", getDataExcepHandler, false, 0, true);
			
			debugTextField = new TextField();
			debugTextField.width = 150;
			debugTextField.background = true;
			debugTextField.backgroundColor = 0XFFFFFF;
			addChild(debugTextField);
			
			rttTxt = new TextField();
			rttTxt.width = 150;
			rttTxt.x = stage.stageWidth - rttTxt.width;
			rttTxt.background = true;
			rttTxt.backgroundColor = 0xffffff;
			addChild(rttTxt);*/
			
			
		}
		
		
		/*function onRankListErrorHandler(evt:RankListEvent):void{
			var obj:Object = evt.data;
			var str:String  = "apiFlag:" + obj.apiName +"   errorCode:" + obj.code +"   message:" + obj.message + "\n";
			rttTxt.text += str; 
		}
		 
		function onRankListSuccessHandler(evt:RankListEvent):void{
			var obj:Object = evt.data;
			rttTxt.text = rttTxt.text + "apiFlag:" + obj.apiName+ "\n";
			 
			var data:* =  obj.data;
			 
			switch(obj.apiName){
				case "1":
					//根据用户名搜索其在某排行榜下的信息
				case "2":
					//根据自己的排名及范围取排行榜信息
				case "4":
					//根据一页显示多少条及取第几条数据来取排行榜信息
					decodeRankListInfo(data);
					break;
				case "3":
					//批量提交成绩至对应的排行榜(numMax<=5,extra<=500B)
					decodeSumitScoreInfo(data);
					break;
				case "5":
					//根据用户ID及存档索引获取存档数据
					decodeUserData(data);
					break;
			}
		}
		 
		private function decodeUserData(dataObj:Object):void{
			if(dataObj == null){
				rttTxt.text += "没有用户数据！\n";
				return;
			}
			var str:String = "存档索引：" + dataObj.index+"\n标题:" + dataObj.title+"\n数据："+dataObj.data+"\n存档时间："+dataObj.datetime+"\n";
			rttTxt.text += str;
		}
		 
		private function decodeSumitScoreInfo(dataAry:Array):void{
			if(dataAry == null || dataAry.length == 0){
				rttTxt.text += "没有数据,返回结果有问题！\n";
				return;
			}
			 
			for(var i in dataAry){
				var tmpObj:Object = dataAry[i];
				var str:String = "第" + (i+1) + "条数据。排行榜ID：" + tmpObj.rId + "，信息码值：" +tmpObj.code +"\n";
				//tmpObj.code == "20005" 表示排行榜已被锁定
				if(tmpObj.code == "10000"){
					str += "当前排名:" + tmpObj.curRank+",当前分数："+tmpObj.curScore+",上一局排名："+tmpObj.lastRank+",上一局分数："+tmpObj.lastScore+"\n";
				}else{
					str += "该排行榜提交的分数出问题了。信息："+tmpObj.message+"\n";
				}
				rttTxt.text += str;
			}
		}
		 
		private function decodeRankListInfo(dataAry:Array):void{
			if(dataAry == null || dataAry.length == 0){
				rttTxt.text += "没有数据！\n";
				return;
			}
			 
			for(var i in dataAry){
				var tmpObj:Object = dataAry[i];
				var str:String = "第" + (i+1) + "条数据。存档索引：" + tmpObj.index+",用户id:" + tmpObj.uId+",昵称："+tmpObj.userName+",分数："+tmpObj.score+",排名："+tmpObj.rank+",来自："+tmpObj.area+",扩展信息："+tmpObj.extra+"\n";
				rttTxt.text += str;
			}
		}

		
		private function saveProcess(e:SaveEvent):void{ 
			switch(e.type){ 
				case SaveEvent.SAVE_GET:
					//读档完成发出的事件
					//index:存档的位置
					//data:存档内容
					//datetime:存档时间
					//title:存档标题
					//e.ret = {"index":0,"data":"abc","datetime":"2010-11-02 16:30:59","title":"标题"}
					break;
				case SaveEvent.SAVE_SET:
					if(e.ret as Boolean == true){
						//存档成功
					}else{
						//存档失败
					}
					break;
				case "saveBackIndex":
					tmpObj = e.ret as Object;
					if(tmpObj == null || int(tmpObj.idx) == -1){
						trace("返回的存档索引值出错了");
						debugTextField.appendText("返回的存档索引值出错了");
						break;
					}
					trace("返回的存档索引值(从0开始算)：" + tmpObj.idx);
					debugTextField.appendText("返回的存档索引值(从0开始算)：" + Main.tmpObj.idx);
					break;
				case SaveEvent.SAVE_LIST:
					var data:Array = e.ret as Array;
					if(data == null) break;
					for(var i:Object in data){
						var obj:Object = data[i];
						if(obj == null) continue;
		 
						//其中status表示存档状态。"0":正常 "1":临时封 "2":永久封
						//当status为"1"(临时封)或"2"(永久封)时，请在存档列表上加以提示
						//在点击该档位且status为"1"(临时封)时，请加带有申诉功能的提示框，允许玩家向客服申诉处理
						//    申诉入口：http://app.my.4399.com/r.php?app=feedback
						//    提供给玩家举报其他作弊玩家的入口：http://app.my.4399.com/r.php?app=feedback-report
						//在点击该档位且status为"2"(永久封)时，请加提示框且无需做申诉处理的功能
						var tmpStr:String = "存档的位置:" + obj.index + "存档时间:" + obj.datetime +"存档标题:"+ obj.title +"存档状态:"+ obj.status;
						trace(tmpStr);
						debugTextField.appendText(tmpStr);
					}
					break;
			}
		}
		
		private function netSaveErrorHandler(evt:Event):void{
			trace("网络存档失败了！"); 
			debugTextField.appendText("网络存档失败了！");
		}
		private function netGetErrorHandler(evt:DataEvent):void{
			var tmpStr:String = "网络取"+ evt.data +"档失败了！";
			trace(tmpStr);
			debugTextField.appendText(tmpStr);
		}
		 
		private function multipleErrorHandler(evt:Event):void{
			trace("游戏多开了！"); 
			debugTextField.appendText("游戏多开了！");
		}
		 
		private function getStoreStateHandler(evt:DataEvent):void{
			//0:多开了，1：没多开，-1：请求数据出错了，-2：没添加存档API的key，-3：未登录不能取状态
			trace(evt.data);
			debugTextField.appendText(evt.data);
		}
		 
		private function getDataExcepHandler(evt:SaveEvent):void{
			//其中status表示存档状态。"0":正常 "1":临时封 "2":永久封
			//当status为"1"(临时封)时，请加带有申诉功能的提示框，允许玩家向客服申诉处理
			//    申诉入口：http://app.my.4399.com/r.php?app=feedback
			//    提供给玩家举报其他作弊玩家的入口：http://app.my.4399.com/r.php?app=feedback-report
			//当status为"2"(永久封)时，请加提示框且无需做申诉处理的功能
			var obj:Object = evt.ret as Object;
			var tmpStr:String = "存档的位置:" + obj.index +"存档状态:"+ obj.status
			trace(tmpStr);
			debugTextField.appendText(tmpStr);
		}*/
 
		


		
		private function logoEnd():void 
		{
			
			
			/*removeChild(logo);
			logo = null;*/
	
			addChild(gameEngine);
		}

	}
	
}