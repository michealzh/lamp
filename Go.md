### func
```go
//func function_name([parameter list]) [return_types]  {
//	函数体
//}

//不支持嵌套,重载,默认参数

//无返回值
func f1() {
}

//返回值是 int 类型
func f2() int {
	return 123
}

//a,b 为int类型形参 int 为指定返回值类型
func f3(a, b int) int {
	return a + b
}

//a,b 为 int 类型形参, c,d 为返回值列表
func f4(a, b int) (c, d int) {
	c = a
	d = b
	return c, d
}

//a,b为 int 类型形参, 返回值为 int,error类型
func f5(a, b int) (int, error) {
	return a + b, nil
}

//... 不定长变参
func f6(a ...int) {

}
//匿名函数
//a := func() {
//	fmt.Println("匿名函数调用")
//}
//a()

type Stu struct {
	height int
	weight int
}

func (Stu) sing(song string) {
	fmt.Println("sing " + song)
}
```
