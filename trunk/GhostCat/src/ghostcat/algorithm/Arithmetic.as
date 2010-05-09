package ghostcat.algorithm
{
	/**
	 * 四则计算
	 * @author flashyiyi
	 * 
	 */
	public class Arithmetic
	{
		private static function isStart(exp:String,i:int):Boolean
		{
			return i <= 0 || exp.charAt(i - 1) == "(";
		}
		private static function isOperator(exp:String,i:int):Boolean 
		{ 
			if (i >= exp.length || i < 0)
				return false;
			
			if (isStart(exp,i))//首字母不是运算符
				return false;
			
			var op:String = exp.charAt(i);
			return op == '+' || (op == "-" && !isOperator(exp,i - 1)) || op == "*" || op == "/";
		}
		
		private static function isNumber(exp:String,i:int):Boolean
		{
			if (i >= exp.length || i < 0)
				return false;
			
			var op:String = exp.charAt(i);
			return op >= '0' && op <= "9" || op == "." || op == "-" && (isOperator(exp,i - 1) || isStart(exp,i));
		}
		
		private static function getPriority(op:String):int 
		{ 
			switch(op)
			{ 
				case ')': 
					return 3; 
				case '*': 
				case '/': 
					return 2; 
				case '+': 
				case '-': 
					return 1; 
				case '(': 
					return -1; 
				default: 
					return 0;
			} 
		}
		
		private static function getValue(op:String, operand1:Number, operand2:Number):Number
		{ 
			switch (op) 
			{ 
				case '*': 
					return(operand2 * operand1); 
				case '/': 
					return(operand2 / operand1); 
				case '-': 
					return(operand2 - operand1); 
				case '+': 
					return(operand2 + operand1);
			}
			return NaN;
		}
		
		
		public static function exec(exp:String):Number
		{ 
			var operator:Array = [];
			var operand:Array = [];
			
			var op:String;
			var operand1:Number;
			var operand2:Number;
			var pos:int=0;
			
			while (pos < exp.length) 
			{ 
				var ch:String = exp.charAt(pos);
				if (ch ==' ') 
				{ 
					pos++; 
				}
				if (ch =='(') 
				{
					operator.push(ch); 
					pos++; 
				}
				else if(ch ==')') 
				{
					op = operator.pop(); 
					while (op != '(') 
					{ 
						operand1 = operand.pop(); 
						operand2 = operand.pop(); 
						operand.push(getValue(op,operand1,operand2)); 
						op = operator.pop(); 
					} 
					pos++; 
				}
				else if (isOperator(exp,pos)) 
				{ 
					while(getPriority(ch) <= getPriority(operator[operator.length - 1]) && operator.length)
					{ 
						op = operator.pop(); 
						operand1=operand.pop(); 
						operand2=operand.pop(); 
						operand.push(getValue(op,operand1,operand2)); 
					} 
					operator.push(exp.charAt(pos));
					pos++; 
				} 
				else 
				{
					var v:String = "";
					while (isNumber(exp,pos) && pos < exp.length)
					{
						v = v + exp.charAt(pos);
						pos++; 
					}
					operand.push(Number(v)); 
				}
				
			}
			
			while (operator.length) 
			{ 
				op = operator.pop(); 
				operand1=operand.pop();
				operand2=operand.pop();
				operand.push(getValue(op,operand1,operand2)); 
			}
			return operand.pop(); 
		}
	}
}

