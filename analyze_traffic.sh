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
