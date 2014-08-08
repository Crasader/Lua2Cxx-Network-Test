Lua2Cxx-Network-Test
====================

消息协议定义规则：
通信协议使用xml文件对每个消息体进行定义，前后端依据每个消息对应的通信协议文件对消息体进行解析和序列化。
通信协议文件以<message>作为根节点，根节点包含若干<field>子节点。每个<field>定义消息体中的一个数据字段，<field>可以包含4种属性。type属性定义此数据字段的数据类型，一共有8种。name属性定义数据字段名称。object属性标识此数据字段是否是一个对象类型。对象类型的<field>可以嵌套若干个<field>作为它的子节点。list属性标识此数据字段是否是一个集合类型，它的直接子节点标识了此集合中每个元素所拥有的数据字段。如果字段定义了object或list属性，那么此字段将忽略type所定义的数据类型。
```<field type = "short" name = "messageType"/>```字段是每个消息协议必须配置的，并作为<message>根节点下的第一个直接子节点。

消息协议：
```
<?xml version="1.0" encoding="UTF-8"?>
<message>
    <field type = "short" name = "messageType"/>
    <field type = "string" name = "string_field"/>
    <field type = "boolean" name = "boolean_field"/>
    <field type = "char" name = "char_field"/>
    <field type = "short" name = "short_field"/>
    <field type = "int" name = "int_field"/>
    <field type = "long" name = "long_field"/>
    <field type = "double" name = "double_field"/>
    <field type = "java.obj" name = "wife" object = "true">
        <field type = "java.obj" name = "wife_name" object = "true">
            <field type = "string" name = "big_name"/>
            <field type = "string" name = "small_name"/>
        </field>
        <field type = "java.obj" name = "kids" list = "true">
            <field type = "string" name = "name"/>
            <field type = "char" name = "age"/>
        </field> 
    </field>
</message>

Lua Table:

local data7 = {
   ["messageType"] = 0,
   ["string_field"] = "wh",
   ["boolean_field"] = true,
   ["char_field"] = 27,
   ["short_field"] = 32767,
   ["int_field"] = 2147483647,
   ["long_field"] = 99999999999999,
   ["double_field"] = 123456789.123456,
   ["wife"] = {
        ["wife_name"] = {
          ["big_name"] = "yj",
          ["small_name"] = "jj"
        },
        ["kids"] = {
            {["name"] = "kid1",["age"] = 1},
            {["name"] = "kid2",["age"] = 2},
            {["name"] = "kid3",["age"] = 3}
        }
    }
}
```
消息体二进制字节流格式定义：
```xxxx|...normal data...|xx|...string data...|xx|...list data...```
前后端通信时发送的每一个消息体都以4个字节的int类型数据作为头部，用来标识此消息体的整体长度为多少字节(不包含头部长度本身)。例如，头部对应的int值为50，则表示此消息体除头部以外的部分还有50字节。头部以外的数据为通信对方发送过来的消息数据，对此部分数据进行解析需要对应其消息协议文件，消息协议的ID为消息数据前两个字节(与messageType对应)。如果消息数据中包含为字符串类型或集合类型的数据，则需要在序列化此数据时加入2个字节的长度信息以表示此字符串数据的长度或集合元素的个数。接收方在解析字符串类型或集合类型的数据时也要先读取2个字节来获取对应的数据信息的长度。


