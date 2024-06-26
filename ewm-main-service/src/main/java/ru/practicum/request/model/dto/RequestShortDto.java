package ru.practicum.request.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ru.practicum.Validator;
import ru.practicum.request.status.Status;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RequestShortDto {
    @NotEmpty(groups = {Validator.Update.class})
    private List<Long> requestIds;

    private Status status;
}
