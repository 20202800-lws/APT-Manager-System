package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
@Table(name = "PROGRAM")
public class Program {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long progId;

    private String progName;
    private String instructor;
    private String targetDay;
    private Integer fee;
    
    @Lob
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Integer capacity;
}