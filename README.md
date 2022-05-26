# 使用方式
导入后使用`about()`，你就会看到

## 流程
```jl
init()		初始化资源
level("a")	打开关卡"a"
此时可以进行一些测试
submit() do
	你的代码
end
来提交（建议在编辑器上编辑好再复制黏贴）
rewind()	重启当前关卡
quit()		退出并保存存档
```

## 辅助工具
```jl
menu()			列出当前所有关卡和描述
vis(false)		关闭窗口
vis(true)		打开窗口
interval		提交时的动画间隔
setinterval(x)	设置动画间隔
```

## 导出的部分函数
| 原型 | 描述 |
| --- | --- |
| `installzip(url)` | 从指定url下载zip |
| `install(owner,repo,version="latest")` | 从`owner`的github仓库`repo`的发布中下载版本`version`，特别地，`latest`表示下载尽可能的最新版 |
| `about()` | 获取相关信息 |
| `menu()` | 列出当前导入数据中的章节和关卡描述 |
| `level(name)` | 导入关卡名为name的关卡，数字会自动转化为字符串 |
| `rewind()` | 重启当前关卡 |
| `submit(f::Function)` | 提交当前关卡的尝试f |
| `setinterval(x::Float64)` | 设置动画间隔 |
| `init(b::Bool=true)` | 初始化数据，其中`b`控制是否导入标准Package项目 |
| `vis(b::Bool)` | 控制窗口可见性 |
| `quit()` | 退出并保存存档 |

# 关卡创建
[标准Package项目地址](https://github.com/JuliaRoadmap/Standard.llp)

目录下应包含以下文件
1. `Project.toml`，至少应包含
	* `name`当前关卡包名
	* `uuid`一个UUID
	* `version`当前版本
	* `description`介绍
	* `[chapters]`，对于每个章节，提供对应的关卡id数组
	* `[compat]`保留
2. `包名.jl`，返回值是一个元组
	* 第一项表示关卡id和对应数据::`Vector{Pair{String,Level}}`
	* 第二项表示build方法，不接受参数

若要支持install方法，应在对应的github仓库发布release，标注恰当的tag（带`v`），在信息中必须含有字段`COMPAT="v版本"`，表示接受的最低LightLearn版本
