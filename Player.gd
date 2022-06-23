extends Area2D

# 定义碰撞信号
signal hit

export var speed = 100
var screen_size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _ready():
	# 初始化时，隐藏玩家
	hide()
	screen_size = get_viewport_rect().size
	
func _process(delta):
	
	# 检查是否在按下了按键
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	# 有动作时播放动画，否则停止动画
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	# 节点的所有属性都可以在此处操作
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# 根据上下不同，切换播放不同的动画
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	# 被击中后消失
	hide()
	# 触发碰撞信号
	emit_signal("hit")
	# 如果在引擎的碰撞处理过程中禁用区域的碰撞形状可能会导致错误。使用 set_deferred() 告诉 Godot 等待可以安全地禁用形状时再这样做。
	$CollisionShape2D.set_deferred("disabled", true)
