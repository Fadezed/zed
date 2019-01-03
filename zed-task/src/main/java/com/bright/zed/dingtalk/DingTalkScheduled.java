package com.bright.zed.dingtalk;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述:
 * dingtalk
 *
 * @author zed
 * @since 2019-01-02 7:44 PM
 */
@Component
public class DingTalkScheduled {

    private static final String URL = "https://oapi.dingtalk.com/robot/send?access_token=9ce013b6f84b63a335eeb60faf59bf7510bd8eca8a073ce2a8e2539b02ba0063";
    private DingtalkChatbotClient client = new DingtalkChatbotClient();

    @Scheduled(cron = "0 0 9 * * ?")
    public void runRobot()throws Exception{
        TextMessage message = new TextMessage("每天起床第一句先给自己打个气！好好学JAVA");
        List<String> atMobiles = new ArrayList<>();
        atMobiles.add("18010816106");
        message.setAtMobiles(atMobiles);
        message.setIsAtAll(false);
        SendResult result = this.client.send(URL, message);
        System.out.println(result);

    }
    @Scheduled(cron = "0 0 9 * * ?")
    public void runRobot1()throws Exception{
        TextMessage message = new TextMessage("上班也要好好学习哦！");
        List<String> atMobiles = new ArrayList<>();
        atMobiles.add("18673130233");
        message.setAtMobiles(atMobiles);
        message.setIsAtAll(false);
        SendResult result = this.client.send(URL, message);
        System.out.println(result);

    }
}

