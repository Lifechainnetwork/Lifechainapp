enum ProposalStatus {
  active,
  passed,
  rejected,
  pending,
  executed
}

enum VoteType {
  yes,
  no,
  abstain
}

class Vote {
  final String voterId;
  final VoteType voteType;
  final double votingPower;
  final DateTime timestamp;
  
  const Vote({
    required this.voterId,
    required this.voteType,
    required this.votingPower,
    required this.timestamp,
  });
}

class Proposal {
  final String id;
  final String title;
  final String description;
  final String creator;
  final DateTime createdAt;
  final DateTime startTime;
  final DateTime endTime;
  final ProposalStatus status;
  final double votingPowerRequired;
  final double votingPowerFor;
  final double votingPowerAgainst;
  final double votingPowerAbstain;
  final List<Vote> votes;
  final String? executionData;
  
  const Proposal({
    required this.id,
    required this.title,
    required this.description,
    required this.creator,
    required this.createdAt,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.votingPowerRequired,
    required this.votingPowerFor,
    required this.votingPowerAgainst,
    required this.votingPowerAbstain,
    required this.votes,
    this.executionData,
  });
  
  double get totalVotingPower => votingPowerFor + votingPowerAgainst + votingPowerAbstain;
  double get quorumPercentage => totalVotingPower / votingPowerRequired * 100;
  double get forPercentage => totalVotingPower > 0 ? (votingPowerFor / totalVotingPower * 100) : 0;
  double get againstPercentage => totalVotingPower > 0 ? (votingPowerAgainst / totalVotingPower * 100) : 0;
  double get abstainPercentage => totalVotingPower > 0 ? (votingPowerAbstain / totalVotingPower * 100) : 0;
  bool get hasQuorum => totalVotingPower >= votingPowerRequired;
  bool get isPassed => hasQuorum && forPercentage > 50;
  
  static List<Proposal> getDemoProposals() {
    final now = DateTime.now();
    
    return [
      Proposal(
        id: 'prop-001',
        title: 'Increase Staking Rewards',
        description: 'Proposal to increase staking rewards from 10% to 15% APY for LCN token stakers to incentivize long-term holding.',
        creator: '0x1234...5678',
        createdAt: now.subtract(const Duration(days: 10)),
        startTime: now.subtract(const Duration(days: 8)),
        endTime: now.add(const Duration(days: 2)),
        status: ProposalStatus.active,
        votingPowerRequired: 1000000,
        votingPowerFor: 650000,
        votingPowerAgainst: 150000,
        votingPowerAbstain: 50000,
        votes: [
          Vote(
            voterId: '0x1234...5678',
            voteType: VoteType.yes,
            votingPower: 250000,
            timestamp: now.subtract(const Duration(days: 7)),
          ),
          Vote(
            voterId: '0x2345...6789',
            voteType: VoteType.yes,
            votingPower: 400000,
            timestamp: now.subtract(const Duration(days: 5)),
          ),
          Vote(
            voterId: '0x3456...7890',
            voteType: VoteType.no,
            votingPower: 150000,
            timestamp: now.subtract(const Duration(days: 3)),
          ),
          Vote(
            voterId: '0x4567...8901',
            voteType: VoteType.abstain,
            votingPower: 50000,
            timestamp: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
      Proposal(
        id: 'prop-002',
        title: 'Add New Liquidity Pool',
        description: 'Proposal to add a new LCN-BTC liquidity pool with 0.3% fee and 80% APR for liquidity providers.',
        creator: '0x2345...6789',
        createdAt: now.subtract(const Duration(days: 15)),
        startTime: now.subtract(const Duration(days: 14)),
        endTime: now.subtract(const Duration(days: 4)),
        status: ProposalStatus.passed,
        votingPowerRequired: 1000000,
        votingPowerFor: 800000,
        votingPowerAgainst: 100000,
        votingPowerAbstain: 50000,
        votes: [
          Vote(
            voterId: '0x1234...5678',
            voteType: VoteType.yes,
            votingPower: 250000,
            timestamp: now.subtract(const Duration(days: 13)),
          ),
          Vote(
            voterId: '0x2345...6789',
            voteType: VoteType.yes,
            votingPower: 400000,
            timestamp: now.subtract(const Duration(days: 12)),
          ),
          Vote(
            voterId: '0x5678...9012',
            voteType: VoteType.yes,
            votingPower: 150000,
            timestamp: now.subtract(const Duration(days: 10)),
          ),
          Vote(
            voterId: '0x3456...7890',
            voteType: VoteType.no,
            votingPower: 100000,
            timestamp: now.subtract(const Duration(days: 8)),
          ),
          Vote(
            voterId: '0x4567...8901',
            voteType: VoteType.abstain,
            votingPower: 50000,
            timestamp: now.subtract(const Duration(days: 6)),
          ),
        ],
        executionData: '0x1234567890abcdef',
      ),
      Proposal(
        id: 'prop-003',
        title: 'Reduce Transaction Fees',
        description: 'Proposal to reduce transaction fees from 0.3% to 0.2% to attract more users and increase trading volume.',
        creator: '0x3456...7890',
        createdAt: now.subtract(const Duration(days: 20)),
        startTime: now.subtract(const Duration(days: 18)),
        endTime: now.subtract(const Duration(days: 8)),
        status: ProposalStatus.rejected,
        votingPowerRequired: 1000000,
        votingPowerFor: 300000,
        votingPowerAgainst: 600000,
        votingPowerAbstain: 50000,
        votes: [
          Vote(
            voterId: '0x1234...5678',
            voteType: VoteType.no,
            votingPower: 250000,
            timestamp: now.subtract(const Duration(days: 17)),
          ),
          Vote(
            voterId: '0x2345...6789',
            voteType: VoteType.no,
            votingPower: 350000,
            timestamp: now.subtract(const Duration(days: 15)),
          ),
          Vote(
            voterId: '0x5678...9012',
            voteType: VoteType.yes,
            votingPower: 300000,
            timestamp: now.subtract(const Duration(days: 12)),
          ),
          Vote(
            voterId: '0x4567...8901',
            voteType: VoteType.abstain,
            votingPower: 50000,
            timestamp: now.subtract(const Duration(days: 10)),
          ),
        ],
      ),
      Proposal(
        id: 'prop-004',
        title: 'Launch NFT Marketplace',
        description: 'Proposal to launch an NFT marketplace for Lifechain users to create, buy, and sell NFTs with low fees.',
        creator: '0x5678...9012',
        createdAt: now.subtract(const Duration(days: 5)),
        startTime: now.subtract(const Duration(days: 3)),
        endTime: now.add(const Duration(days: 7)),
        status: ProposalStatus.active,
        votingPowerRequired: 1000000,
        votingPowerFor: 400000,
        votingPowerAgainst: 200000,
        votingPowerAbstain: 100000,
        votes: [
          Vote(
            voterId: '0x1234...5678',
            voteType: VoteType.yes,
            votingPower: 250000,
            timestamp: now.subtract(const Duration(days: 2)),
          ),
          Vote(
            voterId: '0x2345...6789',
            voteType: VoteType.yes,
            votingPower: 150000,
            timestamp: now.subtract(const Duration(days: 1)),
          ),
          Vote(
            voterId: '0x3456...7890',
            voteType: VoteType.no,
            votingPower: 200000,
            timestamp: now.subtract(const Duration(hours: 12)),
          ),
          Vote(
            voterId: '0x4567...8901',
            voteType: VoteType.abstain,
            votingPower: 100000,
            timestamp: now.subtract(const Duration(hours: 6)),
          ),
        ],
      ),
      Proposal(
        id: 'prop-005',
        title: 'Community Fund Allocation',
        description: 'Proposal to allocate 5% of transaction fees to a community fund for supporting ecosystem growth and development.',
        creator: '0x6789...0123',
        createdAt: now.subtract(const Duration(days: 2)),
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.add(const Duration(days: 9)),
        status: ProposalStatus.active,
        votingPowerRequired: 1000000,
        votingPowerFor: 200000,
        votingPowerAgainst: 50000,
        votingPowerAbstain: 0,
        votes: [
          Vote(
            voterId: '0x1234...5678',
            voteType: VoteType.yes,
            votingPower: 200000,
            timestamp: now.subtract(const Duration(hours: 20)),
          ),
          Vote(
            voterId: '0x3456...7890',
            voteType: VoteType.no,
            votingPower: 50000,
            timestamp: now.subtract(const Duration(hours: 10)),
          ),
        ],
      ),
    ];
  }
}
