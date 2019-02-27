# Redis 基础知识
[TOC]

[TOC]

## 概述
Redis(*瑞戴斯*)是一种`NoSQL`*( **Not Only** SQL)*数据库,内存型数据库,支持*持久化*.

Redis数据存储方式为**Key-Value**,类似于*Memcache*.对于**Value**,Redis支持的数据类型更多([详见下一节](#_2 "数据类型")).

## 数据类型
Redis支持以下5中数据类型:

* **String** (Plain Text)
* **List** (有序的列表)
* **Set** (集合,类似Python的Tuple)
* **Hash** (哈希表)
* **zset** (有序的集合)

基本的操作指令如下.

### String
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th >示例</th>
	</tr>
	<tr>
		<td>
			**SET**
		</td>
		<td>
			设置指定键值的值
		</td>
		<td>
			**set** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**GET**
		</td>
		<td>
			获取指定键值
		</td>
		<td>
			**get** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**DEL**
		</td>
		<td>
			删除指定键值
		</td>
		<td>
			**del** *key_name*
		</td>
	</tr>
</table>

### List
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**RPUSH | LPUSH**
		</td>
		<td>
			将指定元素添加到列表右侧或者左侧
		</td>
		<td>
			**rpush** | **lpush** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**LRANGE**
		</td>
		<td>
			获取列表中指定范围的数据
		</td>
		<td>
			**lrange** *key_name* *start* *end*
		</td>
	</tr>
	<tr>
		<td>
			**LINDEX**
		</td>
		<td>
			获取指定位置的元素
		</td>
		<td>
			**lindex** *key_name* *index*
		</td>
	</tr>
	<tr>
		<td>
			**RPOP | LPOP**
		</td>
		<td>
			从列表的右侧或者左侧取出指定列表的最后一个元素,并将其从列表中删除
		</td>
		<td>
			**rpop** | **lpop** *key_name*
		</td>
	</tr>
</table>

### Sets
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**SADD**
		</td>
		<td>
			将指定元素添加到集合中(*新的元素返回1,已存在的范围0*)
		</td>
		<td>
			**sadd** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**SMEMBERS**
		</td>
		<td>
			获取集合中的数据
		</td>
		<td>
			**smembers** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**SISMEMBER**
		</td>
		<td>
			判断指定元素是否包含在指定集合中
		</td>
		<td>
			**sismember** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**SREM**
		</td>
		<td>
			从集合中删掉指定元素
		</td>
		<td>
			**srem** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**SINTER | SUNION | SDIFF**
		</td>
		<td>
			集合操作- 交集 | 并集 | 差异部分
		</td>
		<td>
			--
		</td>
	</tr>
</table>

### Hashes
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th >示例</th>
	</tr>
	<tr>
		<td>
			**HSET**
		</td>
		<td>
			设置指定键值的值
		</td>
		<td>
			**hset** *hash_key* *sub_key1* *value*
		</td>
	</tr>
	<tr>
		<td>
			**HGET**
		</td>
		<td>
			获取指定键值
		</td>
		<td>
			**hget** *hash_key* *sub_key1*
		</td>
	</tr>
	<tr>
		<td>
			**HGETALL**
		</td>
		<td>
			获取所有的hash键值对
		</td>
		<td>
			**hgetall** *hash_key*
		</td>
	</tr>
	<tr>
		<td>
			**HDEL**
		</td>
		<td>
			删除指定键值
		</td>
		<td>
			**del** *hash_key* *sub_key1*
		</td>
	</tr>
</table>

### ZSets
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**ZADD**
		</td>
		<td>
			将指定元素添加到集合中
		</td>
		<td>
			**zadd** *key_name* *score* *value*
		</td>
	</tr>
	<tr>
		<td>
			**ZRANGE**
		</td>
		<td>
			获取集合中的数据
		</td>
		<td>
			**zrange** *key_name* *start_score* *end_score* **withscore**
		</td>
	</tr>
	<tr>
		<td>
			**ZRANGEBYSCORE**
		</td>
		<td>
			根据Score的范围获取集合中的数据
		</td>
		<td>
			**zrangebyscore** *key_name* *min* *max* **withscore**
		</td>
	</tr>
	<tr>
		<td>
			**ZREM**
		</td>
		<td>
			从集合中删掉指定元素
		</td>
		<td>
			**zrem** *key_name* *value*
		</td>
	</tr>
</table>

## 常用命令

除了上述的基础的操作命令,Redis还包含了许多其他的命令,相关介绍如下.

### Strings

字符串可以用来存储以下类型的数据:

* Byte 字符串
* Int 整数 `(根据服务器运行平台而定最大的长度)`
* Float 浮点数 `(同IEEE 754)`

对于整型和浮点数,Redis提供了以下命令来进行操作
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**INCR**
		</td>
		<td>
			增加指定键值的数据,增量为1
		</td>
		<td>
			**incr** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**DECR**
		</td>
		<td>
			减少指定键值的数据,增量为-1
		</td>
		<td>
			**decr** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**INCRBY**
		</td>
		<td>
			增加指定键值的数据,增量为指定的值
		</td>
		<td>
			**incrby** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**DECRBY**
		</td>
		<td>
			减少指定键值的数据,增量为指定的值
		</td>
		<td>
			**decrby** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**INCRBYFLOAT**
		</td>
		<td>
			增加指定键值的数据,增量为指定的值
		</td>
		<td>
			**incrbyfloat** *key_name* *value*
		</td>
	</tr>
</table>

如果存储的值是字符串类型,而这个值被Redis检测到是可以转换为数值类型的,那么就可以使用`INCR*`和`DECR*`进行数值的变更操作.

而对于字符串类型的值,Redis提供了如下命令:
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**APPEND**
		</td>
		<td>
			将字符串添加到键值对应值的末尾
		</td>
		<td>
			**append** *key_name* *value*
		</td>
	</tr>
	<tr>
		<td>
			**GETRANGE**
		</td>
		<td>
			获取指定键值对应值的子字符串,类似于SubString
		</td>
		<td>
			**getrange** *key_name* *start* *end*
		</td>
	</tr>
	<tr>
		<td>
			**SETRANGE**
		</td>
		<td>
			覆盖指定键值对应值的字符串,起始位置为*offset*,将value覆盖到offset后面
		</td>
		<td>
			**setrange** *key_name* *offset* *value*
		</td>
	</tr>
	<tr>
		<td>
			**GETBIT**
		</td>
		<td>
			获取指定键值对应值的指定位的BIT值
		</td>
		<td>
			**getbit** *key_name* *offset*
		</td>
	</tr>
	<tr>
		<td>
			**SETBIT**
		</td>
		<td>
			设置指定键值对应值的指定位的BIT值
		</td>
		<td>
			**setbit** *key_name* *offset* *value*
		</td>
	</tr>
	<tr>
		<td>
			**BITCOUNT**
		</td>
		<td>
			统计指定键值对应值的BIT位数
		</td>
		<td>
			**bitcount** *key_name* [*start* *end*]
		</td>
	</tr>
	<tr>
		<td>
			**BITOP**
		</td>
		<td>
			将指定的键值的值进行位操作存储到目标键值中去.操作类型包含**AND**,**OR**,**XOR**和**NOT**
		</td>
		<td>
			**bitop** *operation* *dst_key* *key_name* [*key_name* ... ]
		</td>
	</tr>
</table>

### Lists

除了基础的的几个命令外,常用的命令还有:
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**LTRIM**
		</td>
		<td>
			缩减指定键值的List到只包含start到end的元素
		</td>
		<td>
			**ltrim** *key_name* *start* *end*
		</td>
	</tr>
	<tr>
		<td>
			**BLPOP**
		</td>
		<td>
			从指定的键值对应List中移除左边第一个元素,如果是空的List,则阻塞到有一个元素或者超时,多个key时依次取.
		</td>
		<td>
			**blpop** *key_name* [*key_name* ...] *time_out*
		</td>
	</tr>
	<tr>
		<td>
			**BRPOP**
		</td>
		<td>
			从指定的键值对应List中移除右边第一个元素,如果是空的List,则阻塞到有一个元素或者超时,多个key时依次取.
		</td>
		<td>
			**brpop** *key_name* [*key_name* ...] *time_out*
		</td>
	</tr>
	<tr>
		<td>
			**RPOPLPUSH**
		</td>
		<td>
			从源List里面移除右侧第一个元素,并将这个元素存到目标List的左侧,返回这个元素
		</td>
		<td>
			**rpoplpush** *source_key* *dst_key*
		</td>
	</tr>
	<tr>
		<td>
			**BRPOPLPUSH**
		</td>
		<td>
			从源List里面移除右侧第一个元素,并将这个元素存到目标List的左侧,返回这个元素,如果为空则阻塞住
		</td>
		<td>
			**brpoplpush** *source_key* *dst_key* *time_out*
		</td>
	</tr>
</table>

List的*push*|*pop*加上以上的阻塞命令使其非常适合用于消息服务和任务队列.

### Sets

Sets中的元素是唯一的,对于Sets还有以下常用的命令:
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**SCARD**
		</td>
		<td>
			获取指定键值中的元素的数量
		</td>
		<td>
			**scard** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**SRANDMEMBER**
		</td>
		<td>
			随机获取Set中指定数量的元素,当count为正数时,返回的元素唯一,当为负数时,返回的元素可能不唯一
		</td>
		<td>
			**srandmember** *key_name* [*count*]
		</td>
	</tr>
	<tr>
		<td>
			**SPOP**
		</td>
		<td>
			从Set中随机的删除一个元素,并返回这个元素
		</td>
		<td>
			**spop** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**SMOVE**
		</td>
		<td>
			从源Set中找到元素并删除,然后将这个元素移动到目标Set中去,并返回这个元素,如果元素不存在则什么都不做
		</td>
		<td>
			**smove** *source_key* *dst_key* *item*
		</td>
	</tr>
	<tr>
		<td>
			**SDIFFSTORE**
		</td>
		<td>
			将在第一个key里面并不在其他的key里面的元素存储到dst_key的Set中去
		</td>
		<td>
			**sdiffstore** *dst_key* *key_name* [*key_name* ...]
		</td>
	</tr>
	<tr>
		<td>
			**SINTERSTORE**
		</td>
		<td>
			将在所有key的交集元素存储到dst_key的Set中去
		</td>
		<td>
			**sinterstore** *dst_key* *key_name* [*key_name* ...]
		</td>
	</tr>
	<tr>
		<td>
			**SUNIONSTORE**
		</td>
		<td>
			将在所有key的并集元素存储到dst_key的Set中去
		</td>
		<td>
			**sunionstore** *dst_key* *key_name* [*key_name* ...]
		</td>
	</tr>
</table>

### Hashes

除了上述基础命令外,还有以下常用命令来操作Hash集合.
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**HMGET**
		</td>
		<td>
			获取多个指定键的数据
		</td>
		<td>
			**hmget** *key_name* *key* [*key* ...]
		</td>
	</tr>
	<tr>
		<td>
			**HMSET**
		</td>
		<td>
			设置多个键的数据内容
		</td>
		<td>
			**hmset** *key_name* *key* *value* [*key* *value* ...]
		</td>
	</tr>
	<tr>
		<td>
			**HLEN**
		</td>
		<td>
			获取Hash集合的键值对数量
		</td>
		<td>
			**hlen** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**HEXISTS**
		</td>
		<td>
			检查指定的键是否存在
		</td>
		<td>
			**hexists** *key_name* *key*
		</td>
	</tr>
	<tr>
		<td>
			**HKEYS**
		</td>
		<td>
			返回所有键
		</td>
		<td>
			**hkeys** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**HVALS**
		</td>
		<td>
			获取所有值
		</td>
		<td>
			**hvals** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**HINCRBY**
		</td>
		<td>
			增加指定键的数值
		</td>
		<td>
			**hincrby** *key_name* *key* *increment*
		</td>
	</tr>
	<tr>
		<td>
			**HINCRBYFLOAT**
		</td>
		<td>
			增加指定键的数值
		</td>
		<td>
			**hincrbyfloat** *key_name* *key* *increment*
		</td>
	</tr>
</table>

后面的几个命令类似于String的操作命令,而HKEYS和HVALUES在已经有HGETALL的情况下,仅在特殊需求时有作用,如先获取所有键,再获取某些规则下键对应的值.

### ZSets

有序的集合ZSet是我们经常用到的一种数据类型,除了上述命令外,还有以下常用命令.
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**ZCARD**
		</td>
		<td>
			获取集合中的元素数量
		</td>
		<td>
			**zcard** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**ZINCRBY**
		</td>
		<td>
			增加集合中指定元素的值
		</td>
		<td>
			**zincrby** *key_name* *increment* *member*
		</td>
	</tr>
	<tr>
		<td>
			**ZCOUNT**
		</td>
		<td>
			获取指定score在min和max之间的元素
		</td>
		<td>
			**zcount** *key_name* *min* *max*
		</td>
	</tr>
	<tr>
		<td>
			**ZSCORE**
		</td>
		<td>
			获取指定元素的score
		</td>
		<td>
			**zscore** *key_name* *member*
		</td>
	</tr>
	<tr>
		<td>
			**ZRANK**
		</td>
		<td>
			获取指定元素的序号(索引号)
		</td>
		<td>
			**zrank** *key_name* *member*
		</td>
	</tr>
	<tr>
		<td>
			**ZREVRANK**
		</td>
		<td>
			获取指定元素的反向排序的序号(索引号)
		</td>
		<td>
			**zrevrank** *key_name* *member*
		</td>
	</tr>
	<tr>
		<td>
			**ZREVRANGE**
		</td>
		<td>
			按照反向排序从start到end的元素
		</td>
		<td>
			**zrevrange** *key_name* *start* *end*
		</td>
	</tr>
	<tr>
		<td>
			**ZREVRANGEBYSCORE**
		</td>
		<td>
			以score进行排序反向获取指定score范围的数据,并可以指定获取的偏移位置和数量(分页)
		</td>
		<td>
			**zrevrangebyscore** *key_name* *max* *min* \[**withscores**\] [*limit offset count*]
		</td>
	</tr>
	<tr>
		<td>
			**ZREMRANGEBYSCORE**
		</td>
		<td>
			删除score在min和max之间的数据
		</td>
		<td>
			**zremrangebyscore** *key_name* *min* *max*
		</td>
	</tr>
	<tr>
		<td>
			**ZREMRANGEBYRANK**
		</td>
		<td>
			删除正常排序下start到stop之间的数据
		</td>
		<td>
			**zremrangebyrank** *key_name* *start* *stop*
		</td>
	</tr>
	<tr>
		<td>
			**ZINTERSTORE**
		</td>
		<td>
			类似于Set的InterStore,将多个集合的交集存到*dst_key*,需要指定key的数量,可以指定每个集合的权重,要存的元素的score的聚合方式\(默认为sum\)\(**key_name除了ZSet的还可以为Set的,当为Set时,其score按1处理**\)
		</td>
		<td>
			**zinterstore** *dst_key* *key_count* *key_name* \[*key_name* ...\] \[**weights** *weight* \[*weight* ...\]\] \[**aggregates** *sum*|*min*|*max*\]
		</td>
	</tr>
	<tr>
		<td>
			**ZUNIONSTORE**
		</td>
		<td>
			类似于Set的UnionStore,将多个集合的并集存到*dst_key*,需要指定key的数量,可以指定每个集合的权重,要存的元素的score的聚合方式\(默认为sum\)\(**key_name除了ZSet的还可以为Set的,当为Set时,其score按1处理**\)
		</td>
		<td>
			**zunionstore** *dst_key* *key_count* *key_name* \[*key_name* ...\] \[**weights** *weight* \[*weight* ...\]\] \[**aggregates** *sum*|*min*|*max*\]
		</td>
	</tr>
</table>

### Publish/Subscribe

通常也叫做pub/sub,Redis的消息订阅.包含如下命令:
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**SUBSCRIBE**
		</td>
		<td>
			订阅指定的信道
		</td>
		<td>
			**subscribe** *channel* \[*channel* ...\]
		</td>
	</tr>
	<tr>
		<td>
			**UNSUBSCRIBE**
		</td>
		<td>
			取消指定信道的订阅,当未指定channel时,取消所有的订阅
		</td>
		<td>
			**unsubscribe** \[*channel* \[*channel* ...\]\]
		</td>
	</tr>
	<tr>
		<td>
			**PUBLISH**
		</td>
		<td>
			向指定的信道发送信号
		</td>
		<td>
			**publish** *channel* *message*
		</td>
	</tr>
	<tr>
		<td>
			**PSUBSCRIBE**
		</td>
		<td>
			订阅指定的消息类型
		</td>
		<td>
			**psubscribe** *pattern* \[*pattern* ...\]
		</td>
	</tr>
	<tr>
		<td>
			**PUNSUBSCRIBE**
		</td>
		<td>
			取消订阅指定的消息类型,当不指定pattern时,取消所有类型的订阅
		</td>
		<td>
			**punsubscribe** \[*pattern* \[*pattern* ...\]\]
		</td>
	</tr>
</table>

为了更好的说明pub/sub的作用,下面是一个Python的例子:

```python
from redis import Redis

conn = Redis(db=15, host='10.2.25.13')

def publisher(n):
    time.sleep(1)
    for i in xrange(n):
        conn.publish('channel', i)
        time.sleep(1)


def run_pubsub():
    threading.Thread(target=publisher, args=(3,)).start()
    pubsub = conn.pubsub()
    pubsub.subscribe(['channel'])
    count = 0
    for item in pubsub.listen():
        print item
        count += 1
        if count == 4:
            pubsub.unsubscribe()
        if count == 5:
            break
```

运行`run_pubsub`,结果为:

	{'pattern': None, 'type': 'subscribe', 'channel': 'channel', 'data': 1L}
	{'pattern': None, 'type': 'message', 'channel': 'channel', 'data': '0'}
	{'pattern': None, 'type': 'message', 'channel': 'channel', 'data': '1'}
	{'pattern': None, 'type': 'message', 'channel': 'channel', 'data': '2'}
	{'pattern': None, 'type': 'unsubscribe', 'channel': 'channel', 'data': 0L}

在实际使用中,pub/sub也许并没有想象中的有用.主要有以下两个原因:

1. 老版本的subscribe的性能存在问题,可能存在buffer溢出,导致系统崩溃,新版本解决了这个问题,并且提供了参数`client-output-buffer-limit`来保证不会因为subscripe处理不过来导致buffer大到不可接受.
2. 这里的订阅机制并不能保证消息的可靠性.Redis的客户端具有自动重连的机制,如果一个订阅了消息的client在重连之前有pulisher发布的消息,那么这条消息就会丢失.

*可以通过其他的手段来弥补这个缺陷.*


### 其他命令
除了上述的命令之外,还有一些命令可能会用到.

#### Sort
Sort可以用来排序Set,List,ZSet,甚至是Hash,可以把Sort看作Mysql的`Order By`和`Limit`.命令如下:
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**SORT**
		</td>
		<td>
			按照提供的选项对Set,List,ZSet进行排序,返回或者存储排序后的结果
		</td>
		<td>
			**SORT** *key_name* \[**by** *pattern*\] \[**limit** *offset* *count* \] \[**get** *pattern* \[**get** *pattern*\]\] \[**asc** | **desc**\] \[**alpha**\] \[**store** *dst_Key*\]
		</td>
	</tr>
</table>

对于Hash的Sort,下面的命令行例子可能更加清晰:

	sadd watch:leto 12339 1382 338 9338


	hset bug:12339 severity 3
	hset bug:12339 priority 1
	hset bug:12339 details '{"id":12339,....}'

	hset bug:1382 severity 2
	hset bug:1382 priority 2
	hset bug:1382 details '{"id":1382,....}'

	hset bug:338 severity 5
	hset bug:338 priority 3
	hset bug:338 details '{"id":338,....}'

	hset bug:9338 severity 4
	hset bug:9338 priority 2
	hset bug:9338 details '{"id":9338,....}'

	sort watch:leto by bug:*->priority get bug:*->details

	结果为:

>		1) {"id":12339,....}
>		2) {"id":1382,....}
>		3) {"id":9338,....}
>		4) {"id":338,....}

	sort watch:leto by bug:*->priority get bug:*->details store watch_by_priority:leto

#### Transcation
尽管Redis提供了一些命令执行连贯的操作,如上面的`Sort...Store ...`,有时候我们还是需要同时执行几个命令,Redis提供了一些事务的命令:`WATCH`,`MULTI`,`EXEC`,`UNWATCH`和`DISCARD`来完成事务.

Redis的事务是阻止其他的命令执行,而不是像一般的关系型数据一样(一部分一部分的执行,最后回滚或者提交).使用事务的步骤如下:

1. 调用`MULTI`
2. 调用命令
3. 调用`EXEC`

当Redis发现了`MULTI`时会将其他的客户端命令缓存到队列中,直到发现了`EXEC`.

#### Timeout
Redis自带了超时相关命令,使数据尽在时效内有效.相关命令如下:
<table style="width: 100%;text-align: center;">
	<tr>
		<th>命令</th>
		<th>作用</th>
		<th>示例</th>
	</tr>
	<tr>
		<td>
			**PERSIST**
		</td>
		<td>
			删除指定键值的时效,即使之永久有效
		</td>
		<td>
			**persist** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**TTL**
		</td>
		<td>
			获取指定键值的剩余有效时间(单位:`S`)
		</td>
		<td>
			**ttl** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**EXPIRE**
		</td>
		<td>
			设置指定键值的有效时间(单位:`S`)
		</td>
		<td>
			**expire** *key_name* *seconds*
		</td>
	</tr>
	<tr>
		<td>
			**EXPIREAT**
		</td>
		<td>
			设置指定键值的有效时间点(unix timestamp)(精度:`S`)
		</td>
		<td>
			**expireat** *key_name* *timestamp*
		</td>
	</tr>
	<tr>
		<td>
			**PTTL**
		</td>
		<td>
			获取指定键值的剩余有效时间(单位:`MS`) *- Redis 2.6+*
		</td>
		<td>
			**pttl** *key_name*
		</td>
	</tr>
	<tr>
		<td>
			**PEXPIRE**
		</td>
		<td>
			设置指定键值的有效时间(单位:`MS`) *- Redis 2.6+*
		</td>
		<td>
			**pexpire** *key_name* *milliseconds*
		</td>
	</tr>
	<tr>
		<td>
			**EXPIREAT**
		</td>
		<td>
			设置指定键值的有效时间点(unix timestamp)(精度:`MS`) *- Redis 2.6+*
		</td>
		<td>
			**expireat** *key_name* *timestamp-milliseconds*
		</td>
	</tr>
</table>

### 更多命令
以上基本为Redis中常用的命令,更多的命令以及命令详细,参见 [Redis Command](http://10.2.25.13:9292/commands "本地Redis Docs")

## 常见应用

### Cache
Redis常被用来做Cache，我们可以缓存`Render结果`、`DB结果`以及其他数据，通过Expire进行无效的缓存清理。

例如：
	有查询结果A，包含了各种查询条件、排序，最后包含了**Limit**，我们可以把Limit前的数据存到Cache里，设置上超时时间，下次同样的操作，只是Limit不同时则可以直接从Cache中读取数据,这将非常的快。

另外，许多的编程语言都提供了缓存机制，`Redis`也可以用作其缓存，如Python的Django可以配置Cache：

```python
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.filebased.FileBasedCache',
        'LOCATION': '/tmp/django_cache',
    }
}
```

这里将缓存改成`Redis`（*使用Django-Redis扩展库*），而不是使用基于文件的方式。

其他编程语言也有类似的配置。

### 单项排序
由于ZSet的存在，对于单项的排序在Redis中效率非常的高，并且也非常容易取得某个项所在的序号。

例：应用中有个安全评分，评估每个用户的的客户端的安全等级；用户每次上线都会重新评估该等级，然后上传给服务端；服务端提供了评分排行榜，从高到低或者从低到高，并且可以轻松提供指定用户的安全等级所在的排行序号(即使用户量有几百万也很轻松)。

>	设置某个用户的安全等级: 
>	
>		ZADD securesocre <score> <userid>
>
>	得到前100安全等级的的用户: 
>	
>		ZREVRANGE securesocre 0 99
>	或者
>	
>		ZRANGE securesocre 0 99
>
>	得到当前用户的排行:
>	
>		ZRANK securesocre <userid>
>	或者
>	
>		ZREVRANK securesocre <userid>


### 计数
由于`INCR`相关的命令存在，Redis是一个很好的计数器；由于Redis是单线程，也不用担心多个线程同时增减的问题。

例： 统计系统中当前有多少在线用户，多少离线用户；

> 	初始化在线用户和离线用户的数量：
>
>		SET SystemOnlineUserCount:<SystemID> 0
>		SET SystemOfflineUserCount:<SystemID> 10
>	
>	利用计数器,可以增加指定系统ID的在线用户数量并减少离线用户的数量：
>	
>		INCR SystemOnlineUserCount:<SystemID>
>		DECR SystemOfflineUserCount:<SystemID>
>	
>	获取指定系统有多少在线用户：
>	
>		GET SystemOnlineUserCount:<SystemID>		

程序启动时，针对于数据库进行一次统计，初始化计数器的值，后续通过上下线的事件进行相关计数器的变更。

### 统计
与计数类似的是统计，基于`Set`和`ZSet`的`*Card`命令，可以很容易的统计出一个键值中有多少元素，通过`SCAN`可以找出相关的键值；通过`*UNIONSTORE`可以将离散的键值合并起来。

例：我们采用与计数类似的例子，使用`Set`或者`ZSet`来完成计数或者统计。

在线用户统计
>	键值规划如下：
> 
>		  键名字		   所属系统	  所属设备	 接入时间UnixTime(ZSet)	  接入用户ID
>		SystemOnlineUsers:<SystemID>:<DeviceID> [<DatetimeJoinedIFZSet>] <UserID> 
>	获取指定系统的指定设备下有多少在线用户：
>	
>		SCARD SystemOnlineUsers:<SystemID>:<DeviceID>
>	查看当前有多少设备有键值：
>		
>		SCAN 0 MATCH SystemOnlineUsers:<SystemID>:* 
>	有了这些键值之后，便可以将他们聚合起来：
>		
>		SUNIONSTORE SystemOnlineUsers:<SystemID> SystemOnlineUsers:<SystemID>:<DeviceID1> [SystemOnlineUsers:<SystemID>:<DeviceID2>]
>	此时便可以统计指定系统有多少在线用户：
>	
>		SCARD SystemOnlineUsers:<SystemID>
>	同时，还可以查看指定用户是否在线：
>	
>		SISMEMBER SystemOnlineUsers:<SystemID> <UserID>

使用`ZSet`相关命令也基本*类似* ，不过`ZSet`还可以有另外一种用法。

>	键值规划如下：
> 
>		  键名字		   所属系统	  所属设备	 数量 		类型
>		SystemUserCount:<SystemID>:<DeviceID>    <Count>  [OnlineUserCount]
>												<Count>	  [OfflineUserCount]	
>	获取指定系统的指定设备下有多少在线用户：
>	
>		ZSCORE SystemUserCount:<SystemID>:<DeviceID> OnlineUserCount
>	查看当前有多少设备有键值：
>		
>		SCAN 0 MATCH SystemUserCount:<SystemID>:* 
>	有了这些键值之后，便可以将他们聚合起来：
>		
>		ZUNIONSTORE SystemUserCount:<SystemID> SystemUserCount:<SystemID>:<DeviceID1> [SystemUserCount:<SystemID>:<DeviceID2>]
>	此时便可以统计指定系统有多少在线用户：
>	
>		ZSCORE SystemUserCount:<SystemID> OnlineUserCount
>	当然，离线的也可以通过类似的方式获取出来：
>		
>		ZSCORE SystemUserCount:<SystemID> OfflineUserCount
>	另外，还可以用另外一种方式进行数据的存储：
>	
>		  键名字		       所属系统	  	 数量 		所属设备
>		SystemOnlineUserCount:<SystemID>   <Count>     [DeviceID1]
>										   <Count>	   [DeviceID2]	
>	这种方式更容易进行排序操作，但是聚合所有设备的数量时无法直接通过命令处理，需要加入程序或者脚本的控制。


上述Python的Demo程序如下：

```python
# -*- coding: utf-8 -*-
# FileName       : 'CountDemo'
# Create Time    : '2016/5/13 8:59'
# Created By     : 'Benjamin'

"""
文件描述
========

使用方法
--------

"""

import redis
import random
from redis.client import StrictRedis
import time
import pprint

con = StrictRedis(host='10.2.25.13', db=2)
system_names = ["System1", "System2"]
device_names = ["10.2.0.123", "10.2.0.110"]
users = map(lambda x: "user_{0}".format(x), xrange(0, 10001))


def add_data():
    key_format = "SystemOnlineUsersOfSet:{0}:{1}"
    pipe = con.pipeline(False)
    for system_name in system_names:
        for count_date in device_names:
            key = key_format.format(system_name, count_date)

            for x in xrange(0, random.randint(5, 10)):
                cur_user = random.sample(users, 1)[0]
                pipe.sadd(key, cur_user)

    pipe.execute()


def add_data_zSet():
    pipe = con.pipeline(False)
    key_format = "SystemOnlineUsersOfZSet:{0}:{1}"
    for system_name in system_names:
        for count_date in device_names:
            key = key_format.format(system_name, count_date)

            for x in xrange(0, random.randint(5, 10)):
                cur_user = random.sample(users, 1)[0]
                pipe.zadd(key, time.time(), cur_user)

    pipe.execute()


def add_data_zSetOfCount():
    pipe = con.pipeline(False)
    key_format = "SystemUsersCount:{0}:{1}"
    for system_name in system_names:
        for count_date in device_names:
            key = key_format.format(system_name, count_date)
            online_count = random.randint(0, 10)
            offline_count = random.randint(100, 1000)
            pipe.zadd(key, online_count, "OnlineUserCount", offline_count, "OfflineUserCount")

    pipe.execute()


def union_data():
    for system_name in system_names:
        user_count_keys = con.scan(0, 'SystemOnlineUsersOfSet:{0}:*'.format(system_name), count=1000)[1]
        con.sunionstore('SystemOnlineUsersOfSet:{0}'.format(system_name), user_count_keys)

        user_count_keys = con.scan(0, 'SystemOnlineUsersOfZSet:{0}:*'.format(system_name), count=1000)[1]
        con.zunionstore('SystemOnlineUsersOfZSet:{0}'.format(system_name), user_count_keys, aggregate='max')

        user_count_keys = con.scan(0, 'SystemUsersCount:{0}:*'.format(system_name), count=1000)[1]
        con.zunionstore('SystemUsersCount:{0}'.format(system_name), user_count_keys, aggregate='sum')


def show_data():
    print "-" * 40 + "Set" + "-" * 40
    key_format = "SystemOnlineUsersOfSet:{0}:{1}"

    for system_name in system_names:

        for device_name in device_names:
            print key_format.format(system_name, device_name), " -> Users : "
            pprint.pprint(list(con.smembers(key_format.format(system_name, device_name))))

            print key_format.format(system_name, device_name) + " -> Count : " + str(con.scard(
                key_format.format(system_name, device_name)))

        print "SystemOnlineUsersOfSet:{0}".format(system_name), " -> Users : "
        pprint.pprint(list(con.smembers("SystemOnlineUsersOfSet:{0}".format(system_name))))

        print "SystemOnlineUsersOfSet:{0}".format(system_name) + " -> Count : " + str(con.scard(
            "SystemOnlineUsersOfSet:{0}".format(system_name))) + "\n"

    print "-" * 40 + "ZSet" + "-" * 40
    key_format = "SystemOnlineUsersOfZSet:{0}:{1}"

    for system_name in system_names:
        for device_name in device_names:
            print key_format.format(system_name, device_name), " -> Users : "
            pprint.pprint(list(con.zrange(key_format.format(system_name, device_name), 0, 100)))

            print key_format.format(system_name, device_name) + " -> Count : " + str(con.zcard(
                key_format.format(system_name, device_name)))

        print "SystemOnlineUsersOfZSet:{0}".format(system_name), " -> Users : "
        pprint.pprint(list(con.zrange("SystemOnlineUsersOfZSet:{0}".format(system_name), 0, 100)))
        print "SystemOnlineUsersOfZSet:{0}".format(system_name) + " -> Count : " + str(con.zcard(
            "SystemOnlineUsersOfZSet:{0}".format(system_name))) + "\n"

    print "-" * 40 + "ZSetOfCount" + "-" * 40
    key_format = "SystemUsersCount:{0}:{1}"
    for system_name in system_names:
        for device_name in device_names:
            print key_format.format(system_name, device_name) + " -> Count : " + str(con.zrange(
                key_format.format(system_name, device_name), 0, 100, withscores=True))

        print "SystemUsersCount:{0}".format(system_name) + " -> Count : " + str(con.zrange(
            "SystemUsersCount:{0}".format(system_name), 0, 100, withscores=True)) + "\n"


if __name__ == '__main__':
    con.flushdb()

    add_data()
    add_data_zSet()
    add_data_zSetOfCount()
    union_data()
    show_data()
    print "-" * 80

```

输出结果如下:

```
----------------------------------------Set----------------------------------------
SystemOnlineUsersOfSet:System1:10.2.0.123  -> Users : 
['user_7457', 'user_8985', 'user_1510', 'user_5987', 'user_3543']
SystemOnlineUsersOfSet:System1:10.2.0.123 -> Count : 5
SystemOnlineUsersOfSet:System1:10.2.0.110  -> Users : 
['user_9211',
 'user_4220',
 'user_48',
 'user_1120',
 'user_6355',
 'user_9772',
 'user_1792',
 'user_7067',
 'user_1660']
SystemOnlineUsersOfSet:System1:10.2.0.110 -> Count : 9
SystemOnlineUsersOfSet:System1  -> Users : 
['user_8985',
 'user_9211',
 'user_4220',
 'user_7457',
 'user_5987',
 'user_48',
 'user_1120',
 'user_6355',
 'user_1510',
 'user_9772',
 'user_3543',
 'user_1792',
 'user_7067',
 'user_1660']
SystemOnlineUsersOfSet:System1 -> Count : 14

SystemOnlineUsersOfSet:System2:10.2.0.123  -> Users : 
['user_8210',
 'user_1721',
 'user_9742',
 'user_5069',
 'user_8737',
 'user_3122',
 'user_3462',
 'user_4786']
SystemOnlineUsersOfSet:System2:10.2.0.123 -> Count : 8
SystemOnlineUsersOfSet:System2:10.2.0.110  -> Users : 
['user_5137',
 'user_8563',
 'user_3319',
 'user_2790',
 'user_4340',
 'user_3546',
 'user_6826',
 'user_6197',
 'user_8739']
SystemOnlineUsersOfSet:System2:10.2.0.110 -> Count : 9
SystemOnlineUsersOfSet:System2  -> Users : 
['user_5137',
 'user_8563',
 'user_1721',
 'user_9742',
 'user_8210',
 'user_3319',
 'user_2790',
 'user_5069',
 'user_4340',
 'user_8737',
 'user_3122',
 'user_3546',
 'user_3462',
 'user_6826',
 'user_4786',
 'user_6197',
 'user_8739']
SystemOnlineUsersOfSet:System2 -> Count : 17

----------------------------------------ZSet----------------------------------------
SystemOnlineUsersOfZSet:System1:10.2.0.123  -> Users : 
['user_2039', 'user_2836', 'user_5934', 'user_6414', 'user_6524', 'user_8129']
SystemOnlineUsersOfZSet:System1:10.2.0.123 -> Count : 6
SystemOnlineUsersOfZSet:System1:10.2.0.110  -> Users : 
['user_7750', 'user_8164', 'user_9464', 'user_4238', 'user_5770']
SystemOnlineUsersOfZSet:System1:10.2.0.110 -> Count : 5
SystemOnlineUsersOfZSet:System1  -> Users : 
['user_2039',
 'user_2836',
 'user_5934',
 'user_6414',
 'user_6524',
 'user_7750',
 'user_8129',
 'user_8164',
 'user_9464',
 'user_4238',
 'user_5770']
SystemOnlineUsersOfZSet:System1 -> Count : 11

SystemOnlineUsersOfZSet:System2:10.2.0.123  -> Users : 
['user_1200',
 'user_141',
 'user_4116',
 'user_4726',
 'user_5147',
 'user_6151',
 'user_6901',
 'user_7978',
 'user_8532',
 'user_8789']
SystemOnlineUsersOfZSet:System2:10.2.0.123 -> Count : 10
SystemOnlineUsersOfZSet:System2:10.2.0.110  -> Users : 
['user_1169',
 'user_155',
 'user_2578',
 'user_3336',
 'user_4119',
 'user_4332',
 'user_6549',
 'user_8462']
SystemOnlineUsersOfZSet:System2:10.2.0.110 -> Count : 8
SystemOnlineUsersOfZSet:System2  -> Users : 
['user_1169',
 'user_1200',
 'user_141',
 'user_155',
 'user_2578',
 'user_3336',
 'user_4116',
 'user_4119',
 'user_4332',
 'user_4726',
 'user_5147',
 'user_6151',
 'user_6549',
 'user_6901',
 'user_7978',
 'user_8462',
 'user_8532',
 'user_8789']
SystemOnlineUsersOfZSet:System2 -> Count : 18

----------------------------------------ZSetOfCount----------------------------------------
SystemUsersCount:System1:10.2.0.123 -> Count : [('OnlineUserCount', 6.0), ('OfflineUserCount', 764.0)]
SystemUsersCount:System1:10.2.0.110 -> Count : [('OnlineUserCount', 7.0), ('OfflineUserCount', 628.0)]
SystemUsersCount:System1 -> Count : [('OnlineUserCount', 13.0), ('OfflineUserCount', 1392.0)]

SystemUsersCount:System2:10.2.0.123 -> Count : [('OnlineUserCount', 8.0), ('OfflineUserCount', 275.0)]
SystemUsersCount:System2:10.2.0.110 -> Count : [('OnlineUserCount', 7.0), ('OfflineUserCount', 685.0)]
SystemUsersCount:System2 -> Count : [('OnlineUserCount', 15.0), ('OfflineUserCount', 960.0)]

--------------------------------------------------------------------------------
```

**注意：** *借助`Redis`数据结构的特性，我们可以完成一系列在其他数据库不易实现或者性能很低的需求，不过其使用也有一定的限制，比如键值的冲突问题：要统计一个用户在一段时间范围内的上下线次数，仅仅用`ZSet`或者`Set`都无法直接用`用户ID`作为键值，相同的键值在Redis中为**覆盖**作用；也就是说上述的例子，如果我们要统计历史状态时则会变得无效。*

## 内存优化
作为一个内存数据库,减少内存的使用是一项非常重要的事情.通常的内存的优化有三个方向:

1. 短结构
2. 分区结构
3. 字节压缩

### 短结构
所谓的短结构，是指Redis在存储一些数据时，在满足相应条件时会才用压缩等方式来存取数据，以减少内存的开销；Redis提供了相关的配置项进行处理：

```
list-max-ziplist-entries 512
list-max-ziplist-value 64

hash-max-ziplist-entries 512
hash-max-ziplist-value 64

zset-max-ziplist-entries 128
zset-max-ziplist-value 64
```

从如上配置中，`ziplist`仅适合于`List`、`Hash`和`ZSet`；其中`Entries`表示一个键值中允许的最大项目数量，`Value`表示每个项最大的字节数，超过这些值将不再采用ziplist进行值存储。

**注意：** *数据超出`短结构`的配置限定时，`短结构`将会自动转换为`普通结构`，但是当这些超出限定的值被删掉时，`普通结构`并不会重新转换为`短结构`*

除了`ziplist`，还有针对于`Set`的`intset`的短结构，如果某个Set里面的数据全部都是int型数据，那么将会采用`intset`这种短结构进行数据的存储；其也有一个配置决定是否采用短结构,如下：

```
set-max-intset-entries 128
```

关于`entries`的值，有一点需要注意的是，这个值如果设置的太大是会影响性能的，通常建议是`entries`在**500-2000**之间，`value`小于**128**字节。

### 分区结构
所谓分区结构实际是人工缩小键值中项数量的方法，正如上一节所看到的，当项的数量小于配置时，Redis会采用`短结构`进行存储；但是，项目使用过程中不可避免的会出现项的数量大于我们的配置数量，而这种情况下采用手动进行分区，将数据存入不同的键值中，可以继续享受短结构的内存优势。

*如何进行分区全靠经验。* 其中，最简单的就是线性分区，例如，我们有值X需要存到键值Y中，不使用分区的话则为`Y - X`，使用分区的话则为`Y:<分区ID> - X`；线性分区的分区ID则是根据线性算法而来。

**注意：** *分区结构不大适合于`ZSet`和`List`（不易实现）；相对来说在`Hash`和`Set`中更适合。*

### 字节压缩
由于Redis支持字节操作，因此一些特殊的值类型（如枚举），可以使用位图等方式进行数据的压缩，减少内存的消耗。

*这里不进行详细描述*

## Lua
Lua脚本的支持类似于数据库的存储过程，可以完成一些复杂的逻辑，但是需要对Lua脚本语言有一定的了解。

*相关教程可以参见 [Lua中文参考手册](http://cloudwu.github.io/lua53doc/contents.html "http://cloudwu.github.io/lua53doc/contents.html") ，这里不进行详细描述。*

<style>
.toc-right
{
	position: fixed;
	margin-left: 930px;
	top: 100px;
	height: 650px;
	min-width: 300px;
	overflow-y:auto; 
}
</style>
<script type="text/javascript">
	// Fix Second Toc Css, Make Right
	if (document.getElementsByClassName("toc").length == 2){
		document.getElementsByClassName("toc")[1].setAttribute('class','toc-right')
	}
</script>