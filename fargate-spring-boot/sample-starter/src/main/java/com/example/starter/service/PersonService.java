package com.example.starter.service;

import com.example.starter.model.Person;
import com.example.starter.repository.PersonRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PersonService {
    private final PersonRepository repo;

    public PersonService(PersonRepository repo) { this.repo = repo; }

    public List<Person> list() { return repo.findAll(); }
    public Optional<Person> get(Long id) { return repo.findById(id); }
    public Person create(Person p) { return repo.save(p); }
    public Person update(Long id, Person p) {
        p.setId(id);
        return repo.save(p);
    }
    public void delete(Long id) { repo.deleteById(id); }
}
