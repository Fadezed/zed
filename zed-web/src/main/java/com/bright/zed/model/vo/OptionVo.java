package com.bright.zed.model.vo;

import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

/**
 * @author zed
 */
@Data
@ToString
public class OptionVo implements Serializable {
    /**
     * 配置名称
     */
    private String name;

    /**
     * 配置值
     */
    private String value;

    private String description;

    private static final long serialVersionUID = 1L;

}