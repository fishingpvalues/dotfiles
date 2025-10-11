package main

import (
	"fmt"
	"time"
)

// TestStruct demonstrates Go struct with proper tags
type TestStruct struct {
	ID        int       `json:"id" bson:"_id"`
	Name      string    `json:"name" validate:"required"`
	Email     string    `json:"email" validate:"email"`
	CreatedAt time.Time `json:"created_at"`
}

// NewTestStruct creates a new TestStruct instance
func NewTestStruct(id int, name, email string) *TestStruct {
	return &TestStruct{
		ID:        id,
		Name:      name,
		Email:     email,
		CreatedAt: time.Now(),
	}
}

// String implements the Stringer interface
func (t *TestStruct) String() string {
	return fmt.Sprintf("TestStruct{ID: %d, Name: %s, Email: %s}", t.ID, t.Name, t.Email)
}

// Validate checks if the struct is valid
func (t *TestStruct) Validate() error {
	if t.Name == "" {
		return fmt.Errorf("name cannot be empty")
	}
	if t.Email == "" {
		return fmt.Errorf("email cannot be empty")
	}
	return nil
}

func main() {
	// Create a test struct
	test := NewTestStruct(1, "John Doe", "john@example.com")

	// Print the struct
	fmt.Println(test)

	// Validate the struct
	if err := test.Validate(); err != nil {
		fmt.Printf("Validation error: %v\n", err)
		return
	}

	fmt.Println("Struct is valid!")
}