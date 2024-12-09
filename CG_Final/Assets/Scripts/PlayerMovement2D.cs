using UnityEngine;

public class PlayerMovement2D : MonoBehaviour
{
    [Header("Movement Settings")]
    public float moveSpeed = 5f; // Speed of the player
    public float jumpForce = 5f; // Force applied during a jump
    public float fixedZPosition = 0f; // Fixed Z-axis value

    [Header("Ground Check Settings")]
    public Transform groundCheck; // Point to check if the player is grounded
    public float groundCheckRadius = 0.2f; // Radius of the ground check
    public LayerMask groundLayer; // Layer considered as "ground"

    private Rigidbody rb;
    private bool isGrounded;

    void Start()
    {
        // Get the Rigidbody component
        rb = GetComponent<Rigidbody>();

        // Ensure Rigidbody is set up correctly
        if (rb)
        {
            rb.useGravity = true; // Enable gravity for jumping
            rb.constraints = RigidbodyConstraints.FreezeRotation | RigidbodyConstraints.FreezePositionZ;
        }
    }

    void Update()
    {
        // Get input from keyboard (WASD or Arrow Keys)
        float moveX = Input.GetAxis("Horizontal");
        float moveY = Input.GetAxis("Vertical");

        // Calculate movement vector (Z-axis movement is ignored here)
        Vector3 movement = new Vector3(moveX, moveY, 0f) * moveSpeed;

        // Apply movement to Rigidbody
        if (rb)
        {
            rb.velocity = new Vector3(movement.x, movement.y, rb.velocity.z);
        }
        else
        {
            // Fallback for non-Rigidbody objects
            transform.Translate(movement * Time.deltaTime, Space.World);
        }

        // Lock the Z position
        transform.position = new Vector3(transform.position.x, transform.position.y, fixedZPosition);

        // Check if the jump button (Space) is pressed
        if (Input.GetButtonDown("Jump") && isGrounded)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
    }

    void FixedUpdate()
    {
        // Check if the player is grounded using a sphere overlap
        isGrounded = Physics.CheckSphere(groundCheck.position, groundCheckRadius, groundLayer);
    }

    void OnDrawGizmosSelected()
    {
        // Draw the ground check sphere in the editor for visualization
        if (groundCheck != null)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(groundCheck.position, groundCheckRadius);
        }
    }
}
