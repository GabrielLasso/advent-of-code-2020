import parseutils, algorithm, strutils

type
    AstNodeKind = enum Expression, Sum, Product, Number
    AstNode = ref object
        case kind: AstNodeKind
        of Sum, Product:
            left, right: AstNode
        of Expression:
            inner: AstNode
        of Number:
            value: BiggestInt
    Ast = AstNode

proc eval(ast: Ast): BiggestInt =
    case ast.kind:
    of Sum:
        return eval(ast.left) + eval(ast.right)
    of Product:
        return eval(ast.left) * eval(ast.right)
    of Expression:
        return eval(ast.inner)
    of Number:
        return ast.value

type
    TokenKind = enum NumberTk, SumTk, ProductTk, ParenthesisTk
    Token = object
        case kind: TokenKind:
        of NumberTk:
            value: BiggestInt
        of SumTk, ProductTk:
            discard
        of ParenthesisTk:
            inner: seq[Token]

proc tokenize(str: string, index: var int): seq[Token] =
    while index < str.len:
        case str[index]:
        of ' ':
            index += 1
            continue
        of '+':
            index += 1
            result.add(Token(kind: SumTk))
        of '*':
            index += 1
            result.add(Token(kind: ProductTk))
        of '(':
            index += 1
            result.add(Token(kind: ParenthesisTk, inner: tokenize(str, index)))
        of ')':
            index += 1
            return result
        else:
            var v: BiggestInt
            let size = str.parseBiggestInt(v, index)
            index += size
            while (index < str.len and str[index] == ' '):
                index += 1
            result.add(Token(kind: NumberTk, value: v))

proc tokenize(str: string): seq[Token] =
    var index = 0
    result = tokenize(str, index)

proc parse(tokens: seq[Token]): Ast =
    var varTokens = tokens.reversed
    var previousExpression: Ast
    while varTokens.len > 0:
        let token = varTokens.pop
        case token.kind:
        of NumberTk:
            previousExpression = Ast(kind: Number, value: token.value)
        of ParenthesisTk:
            previousExpression = Ast(kind: Expression, inner: parse(token.inner))
        of SumTk:
            previousExpression = Ast(kind: Sum, left: previousExpression, right: parse(@[varTokens.pop]))
        of ProductTk:
            previousExpression = Ast(kind: Product, left: previousExpression, right: parse(@[varTokens.pop]))
    result = previousExpression
    
proc parse2(tokens: seq[Token]): Ast =
    var varTokens = tokens.reversed
    var previousExpression: Ast
    while varTokens.len > 0:
        let token = varTokens.pop
        case token.kind:
        of NumberTk:
            previousExpression = Ast(kind: Number, value: token.value)
        of ParenthesisTk:
            previousExpression = Ast(kind: Expression, inner: parse2(token.inner))
        of SumTk:
            previousExpression = Ast(kind: Sum, left: previousExpression, right: parse2(@[varTokens.pop]))
        of ProductTk:
            # Product has the lower priority, so keep it at the root
            return Ast(kind: Product, left: previousExpression, right: parse2(varTokens))
    result = previousExpression

let input = readFile("input").strip().splitLines

var result = 0'i64
var result2 = 0'i64

for line in input:
    result += line.tokenize.parse.eval
    result2 += line.tokenize.parse2.eval

echo result
echo result2
