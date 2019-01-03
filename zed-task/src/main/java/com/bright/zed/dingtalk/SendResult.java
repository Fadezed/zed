package com.bright.zed.dingtalk;

import com.alibaba.fastjson.JSON;

import java.util.HashMap;
import java.util.Map;

/**
 * 描述:
 * sendResult
 *
 * @author zed
 * @since 2019-01-02 8:17 PM
 */
public class SendResult {
    private boolean isSuccess;
    private Integer errorCode;
    private String errorMsg;

    public SendResult() {
    }

    public boolean isSuccess() {
        return this.isSuccess;
    }

    public void setIsSuccess(boolean isSuccess) {
        this.isSuccess = isSuccess;
    }

    public Integer getErrorCode() {
        return this.errorCode;
    }

    public void setErrorCode(Integer errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMsg() {
        return this.errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }
    @Override
    public String toString() {
        Map<String, Object> items = new HashMap();
        items.put("errorCode", this.errorCode);
        items.put("errorMsg", this.errorMsg);
        items.put("isSuccess", this.isSuccess);
        return JSON.toJSONString(items);
    }
}

