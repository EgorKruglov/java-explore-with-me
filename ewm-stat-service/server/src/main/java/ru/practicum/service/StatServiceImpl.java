package ru.practicum.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.practicum.HitDto;
import ru.practicum.HitResponseDto;
import ru.practicum.exceptions.extraExceptions.ValidationException;
import ru.practicum.model.Hit;
import ru.practicum.model.HitDtoMapper;
import ru.practicum.repository.StatRepository;

import java.time.LocalDateTime;
import java.util.List;

@RequiredArgsConstructor
@Slf4j
@Transactional
@Service
public class StatServiceImpl implements StatService {
    private final StatRepository statRepository;

    @Override
    public HitDto createHit(HitDto hitDto) {
        log.info("Сохранение статистики о запросе");
        Hit hit = statRepository.save(HitDtoMapper.toHit(hitDto));
        return HitDtoMapper.toHitDto(hit);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HitResponseDto> readStat(LocalDateTime start, LocalDateTime end, List<String> uris, boolean unique) {
        log.info("Запрос статистики за период с {} по {}. Уникальные ip = {}", start, end, unique);

        if (start.isAfter(end)) {
            throw new ValidationException("Даты начала выборки позже даты конца.");
        }

        if (uris.isEmpty()) {
            if (unique) {
                return statRepository.findAllByTimestampBetweenStartAndEndWithUniqueIp(start, end);
            } else {
                return statRepository.findAllByTimestampBetweenStartAndEndWhereIpNotUnique(start, end);
            }
        } else {
            if (unique) {
                return statRepository.findAllByTimestampBetweenStartAndEndWithUrisUniqueIp(start, end, uris);
            } else {
                return statRepository.findAllByTimestampBetweenStartAndEndWithUrisIpNotUnique(start, end, uris);
            }
        }
    }
}
