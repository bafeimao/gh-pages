java启动参数共分为三类:

其一是标准参数（-），所有的JVM实现都必须实现这些参数的功能，而且向后兼容；
其二是非标准参数（-X），默认jvm实现这些参数的功能，但是并不保证所有jvm实现都满足，且不保证向后兼容
其三是非Stable参数（-XX），此类参数各个jvm实现会有所不同，将来可能会随时取消，需要慎重使用；
