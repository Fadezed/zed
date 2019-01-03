package com.bright.zed.id;

import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

/**
 * 描述:
 * ID util
 *
 * @author zed
 * @since 2018-12-03 6:14 PM
 */
public class IdUtil {
    /**
     * 返回使用ThreadLocalRandom的UUID，比默认的UUID性能更优
     * @return str
     */
    public static UUID fastUUID() {
        ThreadLocalRandom random = ThreadLocalRandom.current();
        return new UUID(random.nextLong(), random.nextLong());
    }

    /**
     * UUID 剔除-
     * @return str
     */
    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    public static String generateRandomStr(int len) {
        /*
         * 字符源，可以根据需要删减
         */
        String generateSource = "0123456789abcdefghigklmnopqrstuvwxyz";
        StringBuilder rtnStr = new StringBuilder();
        for (int i = 0; i < len; i++) {
            /*
             * 循环随机获得当次字符，并移走选出的字符
             */
            String nowStr = String.valueOf(generateSource.charAt((int) Math.floor(Math.random() * generateSource.length())));
            rtnStr.append(nowStr);
            generateSource = generateSource.replaceAll(nowStr, "");
        }
        return rtnStr.toString();
    }


}