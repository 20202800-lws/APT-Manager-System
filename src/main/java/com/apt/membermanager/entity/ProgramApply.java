package com.apt.membermanager.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Getter @Setter
@Table(name = "PROGRAM_APPLY")
public class ProgramApply {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long applyId;

    @ManyToOne
    @JoinColumn(name = "prog_id")
    private Program program;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String applyStatus; // APPLIED, CANCEL

    @CreationTimestamp
    private LocalDateTime applyDate;
}