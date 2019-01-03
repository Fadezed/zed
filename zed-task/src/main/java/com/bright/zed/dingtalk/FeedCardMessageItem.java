package com.bright.zed.dingtalk;
/**
 * 描述:
 * FeedCardMessageItem
 *
 * @author zed
 * @since 2019-01-02 8:21 PM
 */
public class FeedCardMessageItem {
    private String title;
    private String picURL;
    private String messageURL;

    public String getMessageURL() {
        return messageURL;
    }

    public void setMessageURL(String messageURL) {
        this.messageURL = messageURL;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPicURL() {
        return picURL;
    }

    public void setPicURL(String picURL) {
        this.picURL = picURL;
    }
}