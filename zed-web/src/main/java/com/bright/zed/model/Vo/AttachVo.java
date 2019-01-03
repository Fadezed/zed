package com.bright.zed.model.Vo;

import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

/**
 * @author zed
 */
@Data
@ToString
public class AttachVo implements Serializable {
    private Integer id;

    private String fname;

    private String ftype;

    private String fkey;

    private Integer authorId;

    private Integer created;

    private static final long serialVersionUID = 1L;


}