package gameObjects 
{
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2Vec3;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import citrus.core.starling.StarlingState;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.view.starlingview.StarlingView;
	import flash.geom.Matrix;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import utils.EasyBox2D;
	/**
	 * ...
	 * @author ...
	 */
	public class ViewObject extends DynamicObject 
	{
		
		private var _bodyCenterX:Number = 0;
		private var _bodyCenterY:Number = 0;
		
		private var _matrix:Matrix;
		private var _pos:b2Vec2 = new b2Vec2;
		private var _col1:b2Vec2 = new b2Vec2;
		private var _col2:b2Vec2 = new b2Vec2;
		private var _mat22:b2Mat22 = new b2Mat22;
		private var _transform:b2Transform = new b2Transform;
		
		private var _followView:*;
		
		public function ViewObject(name:String, params:Object = null) 
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void 
		{
			super.initialize(poolObjectParams);
			
		}
		
		override protected function createShape():void 
		{
			_shape = EasyBox2D.createPolygonShape(width, height, new b2Vec2(_width/* / 2*/, _height/* / 2*/));
		}
		
		override protected function defineFixture():void 
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.restitution = 0;
			_fixtureDef.isSensor = true;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("PlayerHand");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}
		
		override protected function defineBody():void 
		{
			super.defineBody();
			_bodyDef.fixedRotation = false;
		}
		
		override protected function createBody():void 
		{
			super.createBody();
			_body.m_customGravity = new b2Vec2(0, 0);
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);			
			updateBodyToView();
			
		}
		
		protected function updateBodyToView():void 
		{
			
			
			
			_matrix = (_followView as DisplayObject).getTransformationMatrix((_ce.state.view as StarlingView).viewRoot);
			if (_invertedViewAndBody == false)
			{
				_col1.Set(_matrix.a, _matrix.b);
			}
			else 
			{
				_col1.Set(-_matrix.a, -_matrix.b);
			}
			_col2.Set(_matrix.c, _matrix.d);
			_mat22.SetVV(_col1, _col2);
			_pos.Set(_matrix.tx / 30, _matrix.ty / 30);
			_transform.Initialize(_pos, _mat22);
			_body.SetTransform(_transform);
			
		}
		
		public function get followView():* 
		{
			return _followView;
		}
		
		public function set followView(value:*):void 
		{
			_followView = value;
		}
		
		public function get bodyCenterX():Number 
		{
			return _bodyCenterX;
		}
		
		public function set bodyCenterX(value:Number):void 
		{
			_bodyCenterX = value;
		}
		
		public function get bodyCenterY():Number 
		{
			return _bodyCenterY;
		}
		
		public function set bodyCenterY(value:Number):void 
		{
			_bodyCenterY = value;
		}
		
	}

}