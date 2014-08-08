Lua2Cxx-Network-Test
====================

消息协议定义规则：
通信协议使用xml文件对每个消息体进行定义，前后端依据每个消息对应的通信协议文件对消息体进行解析和序列化。
通信协议文件以<message>作为根节点。

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
</message>
