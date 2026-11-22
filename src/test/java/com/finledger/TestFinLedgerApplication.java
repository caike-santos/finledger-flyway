package com.finledger;

import org.springframework.boot.SpringApplication;

public class TestFinLedgerApplication {

	public static void main(String[] args) {
		SpringApplication.from(FinLedgerApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
