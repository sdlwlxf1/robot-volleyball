package citrus.input {

	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import flash.events.Event;

	import org.osflash.signals.Signal;
	
	/**
	 * A class managing input of any controllers that is an InputController.
	 * Actions are inspired by Midi signals, but they carry an InputAction object.
	 * "action signals" are either ON, OFF, or VALUECHANGE.
	 * to track action status, and check whether action was just triggered or is still on,
	 * actions have phases (see InputAction).
	 **/	
	public class Input
	{
		protected var _ce:CitrusEngine;
		protected var _enabled:Boolean = true;
		protected var _initialized:Boolean;
		
		protected var _controllers:Vector.<InputController>;
		protected var _actions:Vector.<InputAction>;
		
		public var triggersEnabled:Boolean = true;
		
		protected var _routeActions:Boolean = false;
		protected var _routeChannel:uint;
		
		public var actionTriggeredON:Signal;
		public var actionTriggeredOFF:Signal;
		public var actionTriggeredVALUECHANGE:Signal;
		
		//easy access to the default keyboard
		public var keyboard:Keyboard;
		
		public function Input()
		{
			_controllers = new Vector.<InputController>();
			_actions = new Vector.<InputAction>();
			
			actionTriggeredON = new Signal();
			actionTriggeredOFF = new Signal();
			actionTriggeredVALUECHANGE = new Signal();
			
			actionTriggeredON.add(doActionON);
			actionTriggeredOFF.add(doActionOFF);
			actionTriggeredVALUECHANGE.add(doActionVALUECHANGE);
			
			_ce = CitrusEngine.getInstance();
		}
		
		public function initialize():void
		{
			if (_initialized)
				return;
				
			_ce.stage.addEventListener(Event.FRAME_CONSTRUCTED, update);
			
			//default keyboard
			keyboard = new Keyboard("keyboard");
			
			_initialized = true;
		}
		
		public function addController(controller:InputController):void
		{
			if (_controllers.lastIndexOf(controller) < 0)
				_controllers.push(controller);
		}
		
		public function addAction(action:InputAction):void
		{
			if (_actions.lastIndexOf(action) < 0)
					_actions[_actions.length] = action;
		}
		
		public function controllerExists(name:String):Boolean
		{
			for each (var c:InputController in _controllers)
			{
				if (name == c.name)
					return true;
			}
			return false;
		}
		
		public function getControllerByName(name:String):InputController
		{
			var c:InputController;
			for each (c in _controllers)
				if (name == c.name)
					return c;
			return null;
		}
		
		/**
		 * Returns true if the action has been triggered OFF in this frame or in the previous frame.
		 */
		public function hasDone(actionName:String, channel:uint = 0):Boolean
		{
			var a:InputAction;
			for each (a in _actions)
				if (a.name == actionName && (_routeActions ? (_routeChannel == channel) : a.channel == channel) && a.phase > InputAction.END)
					return true;
			return false;
		}
		
		/**
		 * Returns true if action has just been triggered, or is still on.
		 */
		public function isDoing(actionName:String, channel:uint = 0):Boolean
		{
			var a:InputAction;
			for each (a in _actions)
				if (a.name == actionName && (_routeActions ? (_routeChannel == channel) : a.channel == channel) && a.phase < InputAction.END)
					return true;
			return false;
		}
		
		/**
		 * Returns true if action has been triggered in this frame.
		 */
		public function justDid(actionName:String, channel:uint = 0):Boolean
		{
			var a:InputAction;
			for each (a in _actions)
				if (a.name == actionName && (_routeActions ? (_routeChannel == channel) : a.channel == channel) && a.phase == InputAction.BEGAN)
					return true;
			return false;
		}
		
		/**
		 * Returns true if action has been triggered OFF in this frame.
		 */
		public function justEnd(actionName:String, channel:uint = 0):Boolean
		{
			var a:InputAction;
			for each (a in _actions)
				if (a.name == actionName && (_routeActions ? (_routeChannel == channel) : a.channel == channel) && a.phase == InputAction.END)
					return true;
			return false;
		}
		
		/**
		 * Call this right after justDid, isDoing or hasDone to get the action's value in the current frame.
		 */
		public function getActionValue(actionName:String, channel:uint = 0):Number
		{
			var a:InputAction;
			for each (a in _actions)
				if (actionName == a.name && (_routeActions ? (_routeChannel == channel) : a.channel == channel) && a.value)
					return a.value;
			return 0;
		}
		
		/**
		 * Adds a new action of phase 0 if it does not exist.
		 */
		private function doActionON(action:InputAction):void
		{
			if (!triggersEnabled)
				return;
			var a:InputAction;
			for each (a in _actions)
				if (a.eq(action))
					return;
			action.phase = InputAction.BEGIN;
			_actions[_actions.length] = action;
		}
		
		/**
		 * Sets action to phase 3. will be advanced to phase 4 in next update, and finally will be removed
		 * on the update after that.
		 */
		private function doActionOFF(action:InputAction):void
		{
			if (!triggersEnabled)
				return;
				
			var a:InputAction;
			for each (a in _actions)
				if (a.eq(action))
				{
					a.phase = InputAction.END;
					return;
				}
		}
		
		/**
		 * Changes the value property of an action, or adds action to list if it doesn't exist.
		 * a continuous controller, can simply trigger ActionVALUECHANGE and never have to trigger ActionON.
		 * this will take care adding the new action to the list, setting its phase to 0 so it will respond
		 * to justDid, and then only the value will be changed. - however your continous controller DOES have
		 * to end the action by triggering ActionOFF.
		 */
		private function doActionVALUECHANGE(action:InputAction):void
		{
			if (!triggersEnabled)
				return;
			var a:InputAction;
			for each (a in _actions)
			{
				if (a.eq(action))
				{
					a.phase = InputAction.ON;
					a.value = action.value;
					return;
				}
			}
			action.phase = InputAction.BEGIN;
			_actions[_actions.length] = action;
		}
		
		/**
		 * Input.update is called in the end of your state update.
		 * keep this in mind while you create new controllers - it acts only after everything else.
		 * update first updates all registered controllers then finally
		 * advances actions phases by one if not phase 2 (phase two can only be voluntarily advanced by
		 * doActionOFF.) and removes actions of phase 4 (this happens one frame after doActionOFF was called.)
		 */
		protected function update(e:Event):void
		{
			if (!_enabled)
				return;
			
			var c:InputController;
			for each (c in _controllers)
			{
				if (c.enabled)
					c.update();
			}
			
			var i:String;
			for (i in _actions)
			{
				if (_actions[i].phase > InputAction.END)
					_actions.splice(uint(i), 1);
				else if (_actions[i].phase !== InputAction.ON)
					_actions[i].phase++;
			}
		
		}
		
		public function removeController(controller:InputController):void
		{
			var i:int = _controllers.lastIndexOf(controller);
			removeActionsOf(controller);
			_controllers.splice(i, 1);
		}
		
		public function removeActionsOf(controller:InputController):void
		{
			var i:String;
			for (i in _actions)
				if (_actions[i].controller == controller)
					_actions.splice(uint(i), 1);
		}
		
		public function resetActions():void
		{
			_actions.length = 0;
		}
		
		/**
		 *  addOrSetAction sets existing parameters of an action to new values or adds action if
		 *  it doesn't exist.
		 */
		public function addOrSetAction(action:InputAction):void
		{
			var a:InputAction;
			for each (a in _actions)
			{
				if (a.eq(action))
				{
					a.phase = action.phase;
					a.value = action.value;
					return;
				}
			}
			_actions[_actions.length] = action;
		}
		
		/**
		 *  getActionsSnapshot returns a Vector of all actions in current frame.
		 */
		public function getActionsSnapshot():Vector.<Object>
		{
			var snapshot:Vector.<Object> = new Vector.<Object>;
			for each (var a:InputAction in _actions)
			{
				snapshot.push(new InputAction(a.name, a.controller, a.channel, a.value, a.phase));
			}
			return snapshot;
		}
		
		/**
		 * Start routing all actions to a single channel - used for pause menus or generally overriding the Input system.
		 */
		public function startRouting(channel:uint):void
		{
			_routeActions = true;
			_routeChannel = channel;
		}
		
		/**
		 * Stop routing actions.
		 */
		public function stopRouting():void
		{
			_routeActions = false;
			_routeChannel = 0;
		}
		
		/**
		 * Helps knowing if Input is routing actions or not.
		 */
		public function isRouting():Boolean
		{
			return _routeActions;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			
			var controller:InputController;
			for each (controller in _controllers)
				controller.enabled = value;
			
			_enabled = value;
		}
		
		private function destroyControllers():void
		{
			for each (var c:InputController in _controllers)
			{
				c.destroy();
			}
			_controllers.length = 0;
			_actions.length = 0;
		}
		
		public function destroy():void
		{
			destroyControllers();
			
			actionTriggeredON.removeAll();
			actionTriggeredOFF.removeAll();
			actionTriggeredVALUECHANGE.removeAll();
			
			_ce.stage.removeEventListener(Event.FRAME_CONSTRUCTED,update);
		}
		
		/**
		 * Limited backwards compatibilty for the deprecated justPressed method.
		 * /!\ only works with default key actions defined in the default keyboard instance
		 * (up, down, right, left, up, spacebar)
		 * ultimately, you'll have to convert to the new system :)
		 */
		public function justPressed(keyCode:uint):Boolean
		{
			var keyboard:Keyboard = getControllerByName("keyboard") as Keyboard;
			var actions:Vector.<Object> = keyboard.getActionsByKey(keyCode);
			var a:Object;
			var ia:InputAction;
			if (actions)
			{
				for each (a in actions)
					for each (ia in _actions)
						if (ia.name == a.name && (_routeActions ? (_routeChannel == ((a.channel<0)?keyboard.defaultChannel:a.channel)) : ia.channel == ((a.channel<0)?keyboard.defaultChannel:a.channel)) && ia.phase == InputAction.BEGIN)
							return true;
				return false;
			}
			else
			{
				trace("Warning: you are still using justPressed(keyCode:int) for keyboard input and might get unexpected results...");
				trace("Please use the new justDid(actionName:String, channel:uint) method and convert your code to the Input/InputController Action system !");
				return false;
			}
		}
		
		/**
		 * Limited backwards compatibilty for the deprecated isDown method.
		 * /!\ only works with default key actions defined in the default keyboard instance
		 * (up, down, right, left, up, spacebar)
		 * ultimately, you'll have to convert to the new system :)
		 */
		public function isDown(keyCode:uint):Boolean
		{
			var keyboard:Keyboard = getControllerByName("keyboard") as Keyboard;
			var actions:Vector.<Object> = keyboard.getActionsByKey(keyCode);
			var a:Object;
			var ia:InputAction;
			if (actions)
			{
				for each (a in actions)
					for each (ia in _actions)
						if (ia.name == a.name && (_routeActions ? (_routeChannel == ((a.channel<0)?keyboard.defaultChannel:a.channel)) : ia.channel == ((a.channel<0)?keyboard.defaultChannel:a.channel)) && ia.phase < InputAction.ON)
							return true;
				return false;
			}
			else
			{
				trace("Warning: you are still using isDown(keyCode:int) for keyboard input and might get unexpected results...");
				trace("Please use the new isDoing(actionName:String, channel:uint) method and convert your code to the Input/InputController Action system !");
				return false;
			}
		}
	
	}

}