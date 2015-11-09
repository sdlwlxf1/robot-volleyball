package logics 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Node 
	{
		public var headNode:Node = null;
		public var parent:Node = null;
		public var childs:Vector.<Node> = new Vector.<Node>;
		
		public function Node() 
		{
			
		}
		
		public function addChild(childNode:Node, logic:Logic):void
		{
			childNode.parent = this;
			childs.push(childNode);
			childNode.headNode = this.headNode;
		}
		
		public function removeChild(childNode:Node):void
		{
			childNode.parent = null;
			
			for (var i:int = 0; i < childs.length; i++ )
			{
				if (childNode == childs[i])
				{
					childs.splice(i, 1);
					break;
				}
			}
			
			childNode.headNode = null;
		}
		
		public function getChildByIndex(index:int):Node
		{
			return childs[index < childs.length ? index : childs.length - 1];
		}
		
	}

}