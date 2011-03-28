package ghostcat.util
{
	import flash.external.ExternalInterface;

	/**
	 * 表达式计算
	 * @author flashyiyi
	 * 
	 */
	public class OperatorUtil
	{
		//是否是一元运算符
		private static function isOperatorOneTarget(ch:String):Boolean
		{
			return ch == "!" || ch == "sin"|| ch == "cos"|| ch == "tan"|| ch == "cot"|| ch == "log" || ch == "sqrt" || ch == "round" || ch == "ceil" || ch == "floor";
		}
		
		private static function isNumber(exp:String,i:int):Boolean
		{
			if (i >= exp.length || i < 0)
				return false;
			
			var op:String = exp.charAt(i);
			return op >= "0" && op <= "9" || op == "." || op == "-";
		}
		
		private static function getOperator(exp:String,i:int):String 
		{ 
			var mustOneTarget:Boolean = (i == 0 || !isNumber(exp,i - 1) && exp.charAt(i - 1) != ")");//当没有前一个数字，必须是一元运算符
			var op:String;
			if (i + 4 < exp.length)
			{
				op = exp.slice(i,i + 5);
				if ((!mustOneTarget || isOperatorOneTarget(op)) && 
					(op == "round" || op == "floor"))
					return op;
			}
			if (i + 3 < exp.length)
			{
				op = exp.slice(i,i + 4);
				if ((!mustOneTarget || isOperatorOneTarget(op)) && 
					(op == "sqrt" || op == "ceil"))
					return op;
			}
			if (i + 2 < exp.length)
			{
				op = exp.slice(i,i + 3);
				if ((!mustOneTarget || isOperatorOneTarget(op)) && 
					(op == "pow" || op == "sin" || op == "cos" || op == "tan" || op == "cot" || op == "log"))
					return op;
			}
			if (i + 1 < exp.length)
			{
				op = exp.slice(i,i + 2);
				if ((!mustOneTarget || isOperatorOneTarget(op)) && 
					(op == "<<" || op == ">>" || op == ">=" || op == "<=" || 
					op == "==" || op == "!=" || op == "&&" || op == "||"))
					return op;
			}
			if (i < exp.length)
			{
				op = exp.charAt(i);
				if ((!mustOneTarget || isOperatorOneTarget(op)) && 
					(op == "+" || op == "-" || op == "*" || op == "/" || op == "%" ||
					op == ">" || op == "<" || op == "=" || op == "&" || op == "^" || op == "|" || op == "!"))
					return op;
			}
			return null;
		}
		
		private static function getPriority(op:String):int 
		{ 
			switch(op)
			{ 
				case ")": 
					return uint.MAX_VALUE;
				case "round":
				case "floor":
				case "ceil":
				case "sqrt":
				case "sin":
				case "cos":
				case "tan":
				case "cot":
				case "log":
					return 13;
				case "pow":
					return 12;
				case "!":
					return 11;
				case "*": 
				case "/":
				case "%":
					return 10; 
				case "+": 
				case "-":
					return 9; 
				case "<<":
				case ">>":
					return 8;
				case ">":
				case "<":
				case ">=":
				case "<=":
					return 7;
				case "=":
				case "==":
				case "!=":
					return 6;
				case "&":
					return 5;
				case "^":
					return 4;
				case "|":
					return 3;
				case "&&":
					return 2;
				case "||":
					return 1;
				case "(": 
					return -1; 
				default: 
					return 0;
			} 
		}
		
		private static function getValue(op:String, operand1:Number, operand2:Number):Number
		{ 
			switch (op) 
			{ 
				case "!":
					return operand1 ? 0 : 1;
				case "round":
					return Math.round(operand1);
				case "floor":
					return Math.floor(operand1);
				case "ceil":
					return Math.ceil(operand1);
				case "sqrt":
					return Math.sqrt(operand1);
				case "log":
					return Math.log(operand1);
				case "sin":
					return Math.sin(operand1);
				case "cos":
					return Math.cos(operand1);
				case "tan":
					return Math.tan(operand1);
				case "cot":
					return 1 / Math.tan(operand1);
				case "pow":
					return Math.pow(operand2,operand1);
				case "*": 
					return operand2 * operand1; 
				case "/": 
					return operand2 / operand1;
				case "%":
					return operand2 % operand1;
				case "-": 
					return operand2 - operand1; 
				case "+": 
					return operand2 + operand1;
				case "<<":
					return operand2 << operand1;
				case ">>":
					return operand2 >> operand1;
				case ">":
					return operand2 > operand1 ? 1 : 0;
				case "<":
					return operand2 < operand1 ? 1 : 0;
				case ">=":
					return operand2 >= operand1 ? 1 : 0;
				case "<=":
					return operand2 <= operand1 ? 1 : 0;
				case "=":
				case "==":
					return operand2 == operand1 ? 1 : 0;
				case "!=":
					return operand2 != operand1 ? 1 : 0;
				case "&":
					return operand2 & operand1;
				case "^":
					return operand2 ^ operand1;
				case "|":
					return operand2 | operand1;
				case "&&":
					return operand2 && operand1 ? 1 : 0;
				case "||":
					return operand2 || operand1 ? 1 : 0;
			}
			return NaN;
		}
		
		private static function execOperator(operators:Array,operands:Array):void
		{
			var op:String = operators.pop(); 
			var operand1:Number = operands.pop();
			var operand2:Number;
			if (!isOperatorOneTarget(op))//如果是一元运算符，只取一个值
				operand2 = operands.pop(); 
			operands.push(getValue(op,operand1,operand2)); 
		}
		
		private static function replaceAll(str:String,oldValue:String,newValue:String):String
		{
			var newStr:String = str;
			do
			{
				str = newStr;
				newStr = str.replace(oldValue,newValue);
			}
			while (newStr != str)
			return newStr;
		}
		
		/**
		 * 计算表达式 
		 * @param exp
		 * @return 
		 * 
		 */
		public static function exec(exp:String,params:Object = null):*
		{ 
			if (params)
			{
				for (var p:String in params)
				{
					exp = replaceAll(exp,p,params[p]);
				}
			}
			exp = exp.replace(/\s/g,"");
			
			var operators:Array = [];
			var operands:Array = [];
			
			var pos:int=0;
			
			while (pos < exp.length) 
			{ 
				var ch:String = exp.charAt(pos);
				var operator:String = getOperator(exp,pos);
				if (operator) 
				{ 
					//如果优先级顺序由增加变为减少，则计算比它优先级高的数据直到优先级回到这一级
					while (getPriority(operator) <= getPriority(operators[operators.length - 1]) && operators.length)
						execOperator(operators,operands);
					
					operators.push(operator);
					pos += operator.length; 
				}
				else if (ch == "(") 
				{
					operators.push(ch); 
					pos++; 
				}
				else if (ch == ")") 
				{
					//如果遇到)，则计算数据直到遇到一个(
					while (operators[operators.length - 1] != "(" && operators.length) 
						execOperator(operators,operands);
					
					operators.pop(); 
					pos++; 
				}
				else if (isNumber(exp,pos))
				{
					var v:String = "";
					while (isNumber(exp,pos) && pos < exp.length)
					{
						v = v + exp.charAt(pos);
						pos++; 
					}
					operands.push(Number(v));
				}
				else
				{
					return NaN;
				}
			}
			
			while (operators.length) 
				execOperator(operators,operands);
			
			return operands.pop(); 
		}
		
		/**
		 * 利用浏览器JS计算表达式 
		 * @param exp
		 * @return 
		 * 
		 */
		public static function execByJS(exp:String,params:Object = null):*
		{
			if (params)
			{
				for (var p:String in params)
				{
					exp.replace(new RegExp(p,"g"),params[p]);
				}
			}
			return ExternalInterface.available ? ExternalInterface.call("eval",exp) : null
		}		
	}
}

//D-Eval
//http://www.riaone.com/products/deval/index.html
