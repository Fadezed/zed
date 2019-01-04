package com.bright.zed.model.vo;

import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

/**
 * @author zed
 */
@Data
@ToString
public class MetaVo implements Serializable {
    /**
     * 项目主键
     */
    private Integer mid;

    /**
     * 名称
     */
    private String name;

    /**
     * 项目缩略名
     */
    private String slug;

    /**
     * 项目类型
     */
    private String type;

    /**
     * 选项描述
     */
    private String description;

    /**
     * 项目排序
     */
    private Integer sort;

    private Integer parent;

    private static final long serialVersionUID = 1L;


}