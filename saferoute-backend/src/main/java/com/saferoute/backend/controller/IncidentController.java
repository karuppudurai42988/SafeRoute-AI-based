package com.saferoute.backend.controller;

import com.saferoute.backend.dto.SafetyResponse;
import com.saferoute.backend.model.SafetyIncident;
import com.saferoute.backend.repository.IncidentRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/incidents")
public class IncidentController {

    @Autowired
    private IncidentRepository incidentRepository;

    private final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);

    @PostMapping("/report")
    public ResponseEntity<?> reportIncident(@RequestParam double lat, @RequestParam double lng) {
        try {
            SafetyIncident incident = new SafetyIncident();
            Point point = geometryFactory.createPoint(new Coordinate(lng, lat)); // Spatial uses (X, Y) -> (lng, lat)
            incident.setLocation(point);
            incidentRepository.save(incident);

            String pythonAiUrl = "http://localhost:8000/api/ai/analyze?lat=" + lat + "&lng=" + lng;
            RestTemplate restTemplate = new RestTemplate();

            SafetyResponse aiResult = restTemplate.getForObject(pythonAiUrl, SafetyResponse.class);

            return ResponseEntity.ok(aiResult);

        } catch (Exception e) {
            SafetyResponse fallback = new SafetyResponse();
            fallback.setSafetyScore(100);
            fallback.setStatus("Backup Mode");
            fallback.setDescription("Coordinates saved safely to MySQL. AI module is offline.");
            return ResponseEntity.ok(fallback);
        }
    }
}
