package com.bright.zed.model.Vo;

import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

/**
 * @author zed
 */
@Data
@ToString
public class RelationshipVoKey implements Serializable {
    /**
     * 内容主键
     */
    private Integer cid;

    /**
     * 项目主键
     */
    private Integer mid;

    private static final long serialVersionUID = 1L;

}