redis_capacity_calc

string类型的内存大小 = 键值个数 * (dictEntry大小 + redisObject大小 + 包含key的sds大小 + 包含value的sds大小) + bucket个数 * 4

=====================================
Example1: string： counter:000000000000 = 333 (100001)

其中:len("counter:000000000000") = 20
存储dictEntry的桶的大小是dictEntry个数向上求整的2的n次方,因此此例子中是2^17 = 131072 (>100001)

预估：
100001 * (16 + 0 (因为值是数字并且小于10000（该值由REDIS_SHARED_INTEGERS指定）因此redisObject对象被省略) + 32（key的大小为20向上取） + 0（被存到dictEntry中了）) + 131072 * 4

因此最终计算的占用内存为：100001*48 + 131072 * 4 =  5324336 = 5M

=====================================
Example2: string： key:000000000000 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (100001)

预估值= 100001 * （16+16+ 32 + 64) + 131072 * 4 = 13324416 = 13M



