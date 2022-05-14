<div align="center">

<img alt="LOGO" src="![bk](https://user-images.githubusercontent.com/75256484/168429539-8f24bd69-6a09-46e9-ac7e-a24a9312c553.png)" width=300 height=300/>

# rv32cpu-bk0717a

<br>
</div>
A simple CPU design based on RV32I instruction set and Xilinx FPGA.

## 简介

- RISC-V架构单周期CPU，字长32位，目前只实现了RV32I中部分指令
- 哈佛结构，指令储存在ROM中，数据储存在RAM中
- CPU命名为BK0717A，A表示Alpha，这是我写的第一个CPU，也是初期版本

## 目录结构

```
.
│  LICENSE
│  README.md
│  
├─coe
|      rom.coe
|
├─constrs
│      bk0717a.xdc :vivado约束文件
│      
├─lib :通用模块库
│  │  constant.v :定义常量
│  │  Mux32_2_1.v :32位2选1MUX（例化MuxKey）
│  │  Mux32_8_1.v :32位8选1MUX（例化MuxKey）
│  │  Reg.v :参数化寄存器
│  │  
│  ├─Adder :加法器
│  │      Adder32.v
│  │      Adder4.v
│  │      
│  └─MuxKey :参数化MUX
│          MuxKey.v
│          MuxKeyInternal.v
│          MuxKeywithDefault.v
│      
├─src :各模块源码
│      AccessMem.v :访存模块
│      ALU32.v :ALU模块
│      BK0717A.v :bk0717a顶层模块
│      Core.v :核心模块
│      Decoder.v :译码模块
│      PC32.v :PC模块（取指）
│      RegFIle32.v :通用寄存器组模块
│      WriteBack.v :写回模块
│      
└─utils :顶层模块中用于FPGA实验板调试的模块
        Button.v :按键消抖输入模块
        Seg16.v :数码管显示模块
```

## 测试环境

- 硬件测试平台为学校实验室提供的FPGA实验板，芯片为Kintex7 XC7K160T-2FBG676I，软件为Vivado 2018.3
- ROM和RAM使用了Vivado提供的IP核，ROM为256x32bit，RAM采用分体结构，由4块64x8bit的单元组成
- 测试程序使用[rars](https://github.com/TheThirdOne/rars)生成，并使用rars作为运行对照。（感谢rars）
