package ru.practicum.user.model.dto;

import lombok.Builder;
import lombok.Data;
import ru.practicum.Validator;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

@Data
@Builder
public class UserDto {
    @NotNull(groups = {Validator.Create.class})
    private Long id;

    @NotEmpty(groups = {Validator.Create.class})
    private String name;
}