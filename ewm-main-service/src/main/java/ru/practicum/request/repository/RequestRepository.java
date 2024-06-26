package ru.practicum.request.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import ru.practicum.request.model.Request;
import ru.practicum.request.model.dto.EventConfirmedRequests;

import java.util.List;

@Repository
public interface RequestRepository extends JpaRepository<Request, Long> {

    @Query("SELECT new ru.practicum.request.model.dto.EventConfirmedRequests(r.event.id , count(r.id)) " +
            "FROM Request r " +
            "WHERE r.event.id in ?1 " +
            "AND r.status = 'CONFIRMED' " +
            "GROUP BY r.event.id ")
    List<EventConfirmedRequests> countByEventId(List<Long> longs);

    boolean existsByRequesterIdAndEventId(long userId, long eventId);

    List<Request> findAllByRequesterId(long userId);

    List<Request> findAllByEventId(long eventId);
}
