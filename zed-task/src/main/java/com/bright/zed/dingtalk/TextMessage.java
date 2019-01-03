package com.bright.zed.dingtalk;

import com.alibaba.fastjson.JSON;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述:
 * textMessage
 *
 * @author zed
 * @since 2019-01-02 8:21 PM
 */
public class TextMessage implements Message {

    private String text;
    private List<String> atMobiles;
    private boolean isAtAll;

    public TextMessage(String text) {
        this.text = text;
    }

    public String getText() {
        return this.text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public List<String> getAtMobiles() {
        return this.atMobiles;
    }

    public void setAtMobiles(List<String> atMobiles) {
        this.atMobiles = atMobiles;
    }

    public boolean isAtAll() {
        return this.isAtAll;
    }

    public void setIsAtAll(boolean isAtAll) {
        this.isAtAll = isAtAll;
    }
    @Override
    public String toJsonString() {
        Map<String, Object> items = new HashMap<>();
        items.put("msgtype", "text");
        Map<String, String> textContent = new HashMap<>();
        if (StringUtils.isEmpty(this.text)) {
            throw new IllegalArgumentException("text should not be blank");
        } else {
            textContent.put("content", this.text);
            items.put("text", textContent);
            Map<String, Object> atItems = new HashMap<>();
            if (this.atMobiles != null && !this.atMobiles.isEmpty()) {
                atItems.put("atMobiles", this.atMobiles);
            }

            if (this.isAtAll) {
                atItems.put("isAtAll", this.isAtAll);
            }

            items.put("at", atItems);
            return JSON.toJSONString(items);
        }
    }
}

