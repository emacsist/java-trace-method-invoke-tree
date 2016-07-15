# java-trace-method-invoke-tree
java-trace-method-invoke-tree

## 起因

本人一直想寻找一种监控工具来监控我们项目包里所有方法的调用时间.但Google了很久, 都一直没有能找到如意的工具. 现有的监控工具,都只是如下:

1. 可以监控每个方法的调用时间. 不过代码入侵性太高, 所以觉得不好. 要添加或移除这些代码真心是不舒服.

2. Spring AOP. 这种AOP, 限制太多.

本人一直想要一种这样子的监控工具:

(1) 可以将执行线程的所有调用方法及耗时的调用树及其每个方法的耗时打印出来.
(2) 无代码入侵性.(或极少入侵性).
(3) 使用简单.

经过这几天苦苦的探索. 发现`Aspectj` 符合`无入侵性`. 至于第一点, 刚好有个同事发现了`greys-anatomy`这个项目, 自己也试用了下, 发现里面的方法调用栈输出的形式, 也正是本人非常想要的.

所以, 这样一个项目就出来了.

利用 `aspectj`收集方法调用树保存到`greys-anatomy`的调用树数据结构里. ^_^

利用 AspectJ 来监控整个JVM中所指定的包及其类的方法的调用树及耗时. 并打印出来.

## 使用

配置好AspectJ开发环境, 然后将这两个类集成到你的项目包里, 最后使用AspectJ编译即可.


## 结果

```bash
`---+Tracing for : main
        `---+[3002,3001ms]StaticPartImpl:HelloWorld.main(..)(@HelloWorld.java:8)
            +---+[1,0ms]StaticPartImpl:SigUtils.sayHello()(@SigUtils.java:28)
            |   `---[1,0ms]StaticPartImpl:SigUtils.say()(@SigUtils.java:18)
            `---+[3002,3001ms]StaticPartImpl:SigUtils.other()(@SigUtils.java:22)
                `---[1,0ms]StaticPartImpl:SigUtils.say()(@SigUtils.java:18)
```

本项目的代码, 使用了 [greys-anatomy](https://github.com/oldmanpushcart/greys-anatomy) 项目的 `TTree` 类, 并作了小小的修改.

## 关于输出结果

[xxx,yyyms]: 这个其实和`greys-anatomy`的`trace`命令输出是一样的.
即: 

xxx: 表示运行到该节点时的总时间.
yyy: 表示该节点自身使用的时间.


`greys-anatomy` 项目是一个非常优秀的在线性能排查工具. 具体的情况, 可以参考其文档及用法.






