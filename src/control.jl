function _draw()
    ctx=getgc(canvas)
	cacx=plyx # 缓存
	cacy=plyy
	for i in 1:16
		for j in 1:16
			if i!=cacx||j!=cacy
				show_grid(ctx,@inbounds(grids[i,j]),(i-1)<<5,(j-1)<<5)
			else
				fill_image(ctx,"ply",i<<5-30,j<<5-30)
			end
		end
	end
	set_source_rgb(ctx,0.625,0.625,0.625)
	for k in 1:16
		rectangle(ctx,k<<5-1,0,1,512)
		rectangle(ctx,0,k<<5-1,512,1)
	end
	fill(ctx)
end
function about()
	display(md"""
# 流程
```jl
init()		初始化资源
level(name)	打开关卡name
此时可以进行一些测试
submit() do
	你的代码
end
来提交（建议在编辑器上编辑好再复制黏贴）
quit()		退出并保存存档
```

# 辅助工具
```jl
menu()		列出当前所有关卡和描述
vis(false)	关闭窗口
vis(true)	打开窗口
interval	提交时的动画间隔
```

# 关卡导入
```jl
init(false)	初始化时不导入默认关卡
loaddir(s)	导入s处的目录所含数据
```
	""")
end
function menu()
	for pa::Pair in chapters
		println("[ $(pa.first) ]")
		for name in pa.second
			println("$name\t$(levels[name].description)")
		end
	end
end
function initlevel(lv::Level)
	global plyx=lv.startx
	global plyy=lv.starty
	lv.gen()
	draw(canvas)
end
level(num::Int)=level(string(num))
function level(name::String)
	global levelid=name
	lv=levels[name]
	set_gtk_property!(window,:title,"LightLearn: $(lv.description)")
	initlevel(lv)
	plyenter(grids[lv.startx,lv.starty])
end
struct LiError
	name::Symbol
end
mvw()=move(0,-1)
mva()=move(-1,0)
mvs()=move(0,1)
mvd()=move(1,0)
function move(x::Int,y::Int)
	tx=plyx+x
	ty=plyy+y
	if tx<1||tx>16||ty<1||ty>16||solid(@inbounds(grids[tx,ty]))
		return
	end
	global plyx=tx
	global plyy=ty
	plyenter(grids[tx,ty])
	if formal
		sleep(interval)
	end
	draw(canvas)
end
function submit(f::Function)
	lv=levels[levelid]
	initlevel(lv)
	global formal=true
	try
		plyenter(grids[lv.startx,lv.starty])
		f()
		if !lv.chk()
			printstyled("未达成目标";color=:yellow)
			return
		end
		printstyled("通过！ 步数：$count";color=:green)
		if haskey(records,levelid)
			@inbounds if records[levelid]>count
				records[levelid]=count
			end
		else
			records[levelid]=count
		end
	catch er
		if isa(er,LiError)
			sy=er.name
			printstyled("Error: ",
				sy==:cheat ? "禁止作弊" :
				sy==:invisible_far ? "太远了，无法调用look()" :
				"[未知]";color=:red
			)
		else
			throw(er)
		end
	finally
		formal=false
	end
	nothing
end

function chknear(x::Int,y::Int)
	if abs(x-plyx)+abs(y-plyy)>1
		throw(LiError(:invisible_far))
	end
end
function look(x::Int,y::Int)
	chknear(x,y)
	if x<1||y<1||x>16||y>16
		return Solid()
	end
	v=@inbounds grids[x,y]
	return _look(v)
end
function guess(x::Int,y::Int,v)
	chknear(x,y)
	return _guess(grids[x,y],v)
end
