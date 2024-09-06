# Network Traffic Analysis Script

This Bash script analyzes network traffic from a pcap (packet capture) file created by Wireshark. It provides a summary of packet counts, protocol usage, and the most frequent source and destination IP addresses.

## Science Behind the Script

Network traffic analysis involves examining the data packets that travel over a network. These packets include various types of information, such as:

- Packet Headers: Contain metadata about the packet, including source and destination IP addresses, and protocol information.

- Packet Payloads: Contain the actual data being transmitted, such as web content, files, or messages.

In this script, we assume that packets have been captured from a network interface card connected via WiFi. The script helps in monitoring and analyzing these packets by:

1. Counting Total Packets: Provides a count of all packets captured in the pcap file.

2. Identifying Protocol Usage: Counts packets for specific protocols, such as HTTP and HTTPS/TLS, to understand the types of traffic.

3. Determining Top IP Addresses: Lists the most frequent source and destination IP addresses to identify which devices are most active in the network traffic.

## Code Explanation

```BASH
#!/bin/bash

# Input: Path to the Wireshark pcap file
pcap_file=$1

# Function to analyze traffic and generate report
analyze_traffic() {
  echo "----- Network Traffic Analysis Report -----"
  echo ""
  
  # 1. Total Packets
  total_packets=$(tshark -r "$pcap_file" | wc -l)
  echo "1. Total Packets: $total_packets packet"

  # 2. Protocols (HTTP and HTTPS)
  http_packets=$(tshark -r "$pcap_file" -Y http | wc -l)
  https_packets=$(tshark -r "$pcap_file" -Y tls | wc -l)
  echo "2. Protocols:"
  echo "  - HTTP: $http_packets packets"
  echo "  - HTTPS/TLS: $https_packets packets"
  echo ""

  # 3. Top 5 Source IP Addresses
  echo "3. Top 5 Source IP Addresses:"
  tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -n 5

  echo ""

  # 4. Top 5 Destination IP Addresses
  echo "4. Top 5 Destination IP Addresses:"
  tshark -r "$pcap_file" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -n 5
  echo""

  echo "----- End of Report -----"
}

# Run the analysis function
analyze_traffic

```

## Commands Explanation

1. `tshark -r "$pcap_file"`
    
    -  **Description:** This command reads the pcap file specified by the variable `$pcap_file`. `tshark` is the command-line version of Wireshark, which allows us to analyze packet captures from the command line.

    - **Flags:**
        - `-r`: Specifies the file to read from. This flag is essential for indicating the input file for analysis.

2. `wc -l` 
   
   -  **Description:** The `wc` command stands for "word count," and the -l flag tells it to count lines. In this script, it's used to count the number of packets by counting the lines output by `tshark`.

3. `tshark -r "$pcap_file" -Y http`
    
    - **Description**: This command filters the packets to 
    show only HTTP traffic.
    
    - **Flags**:
        - `-Y`: Applies a display filter. Here, `http` is used as the filter to show only HTTP packets. This helps in focusing on specific types of traffic.

4. `tshark -r "$pcap_file" -Y tls`
    
    - **Description**: This command filters the packets to 
    show only tls traffic.
    
    - **Flags**:
        - `-Y`: Applies a display filter. Here, `tls` is used as the filter to show only TLS packets. (Transport Layer Security), which is used in HTTPS.

5. `tshark -r "$pcap_file" -T fields -e ip.src/ip.dst`
    
    - **Description**: This command extracts the source/destination IP addresses from the pcap file.
    
    - **Flags**:
        - `-T fields`: Specifies that the output should be in a fields format, allowing us to extract specific fields from the packet data.
        - `e ip.src/dst`:Indicates that we want to extract the source/destination IP address field.

6. `sort | uniq -c | sort -nr | head -n 5`

    - `Description`: This series of commands processes the list of IP addresses to determine the most frequent ones.

    - `Commands`:
        - `sort`: Sorts the IP addresses.

        - `uniq -c`: Counts the occurrences of each unique IP address.

        - `sort -nr`: Sorts the results numerically in reverse order, so the most frequent IP addresses come first.

        - `head -n 5`: Displays the top 5 entries, which are the most frequent IP addresses.        











