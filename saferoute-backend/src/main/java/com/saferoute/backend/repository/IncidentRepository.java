package com.saferoute.backend.repository;

import com.saferoute.backend.model.SafetyIncident;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IncidentRepository extends JpaRepository<SafetyIncident, Long> {}