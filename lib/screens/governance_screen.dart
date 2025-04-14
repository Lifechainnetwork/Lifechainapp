import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/proposal.dart';
import '../widgets/proposal_card.dart';
import '../widgets/custom_card.dart';

class GovernanceScreen extends StatefulWidget {
  const GovernanceScreen({super.key});

  @override
  State<GovernanceScreen> createState() => _GovernanceScreenState();
}

class _GovernanceScreenState extends State<GovernanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Proposal> _proposals = [];
  final double _userVotingPower = 500000; // Demo value

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProposals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProposals() async {
    // Simulate loading from API
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _proposals = Proposal.getDemoProposals();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Governance'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Passed'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildProposalList(ProposalStatus.active),
                  _buildProposalList(ProposalStatus.passed),
                  _buildProposalList(ProposalStatus.rejected),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateProposalDialog(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProposalList(ProposalStatus status) {
    final filteredProposals =
        _proposals.where((proposal) => proposal.status == status).toList();

    if (filteredProposals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getEmptyStateIcon(status), size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateText(status),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyStateSubtext(status),
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status == ProposalStatus.active) _buildGovernanceHeader(),
          const SizedBox(height: 16),
          ...filteredProposals.map(
            (proposal) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProposalCard(
                proposal: proposal,
                onViewDetails:
                    () => _showProposalDetailsDialog(context, proposal),
                onVote:
                    status == ProposalStatus.active
                        ? () => _showVoteDialog(context, proposal)
                        : null,
                onExecute:
                    status == ProposalStatus.passed &&
                            proposal.executionData != null
                        ? () => _executeProposal(context, proposal)
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernanceHeader() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Governance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Participate in the decision-making process of the Lifechain ecosystem',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.dividerColor),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox(
                'Your Voting Power',
                '${_formatNumber(_userVotingPower)} LCN',
              ),
              _buildInfoBox(
                'Active Proposals',
                _proposals
                    .where((p) => p.status == ProposalStatus.active)
                    .length
                    .toString(),
              ),
              _buildInfoBox('Total Proposals', _proposals.length.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.active:
        return Icons.how_to_vote;
      case ProposalStatus.passed:
        return Icons.check_circle;
      case ProposalStatus.rejected:
        return Icons.cancel;
      default:
        return Icons.description;
    }
  }

  String _getEmptyStateText(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.active:
        return 'No Active Proposals';
      case ProposalStatus.passed:
        return 'No Passed Proposals';
      case ProposalStatus.rejected:
        return 'No Rejected Proposals';
      default:
        return 'No Proposals';
    }
  }

  String _getEmptyStateSubtext(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.active:
        return 'Create a proposal to start voting';
      case ProposalStatus.passed:
        return 'Proposals that pass voting will appear here';
      case ProposalStatus.rejected:
        return 'Proposals that fail voting will appear here';
      default:
        return 'No proposals found';
    }
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  void _showProposalDetailsDialog(BuildContext context, Proposal proposal) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: Text(proposal.title),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Created by ${proposal.creator}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(proposal.description),
                    const SizedBox(height: 16),
                    const Text(
                      'Voting Progress',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildVotingDetails(proposal),
                    const SizedBox(height: 16),
                    const Text(
                      'Timeline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimelineItem('Created', proposal.createdAt),
                    _buildTimelineItem('Voting Started', proposal.startTime),
                    _buildTimelineItem('Voting Ends', proposal.endTime),
                    const SizedBox(height: 16),
                    const Text(
                      'Votes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...proposal.votes.map((vote) => _buildVoteItem(vote)),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              if (proposal.status == ProposalStatus.active)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showVoteDialog(context, proposal);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Vote'),
                ),
            ],
          ),
    );
  }

  Widget _buildVotingDetails(Proposal proposal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quorum: ${proposal.quorumPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: proposal.hasQuorum ? Colors.green : Colors.grey[400],
                fontSize: 14,
                fontWeight:
                    proposal.hasQuorum ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              'Required: ${_formatNumber(proposal.votingPowerRequired)} LCN',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 8,
                  width: proposal.forPercentage * 3,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(4),
                      bottomLeft: const Radius.circular(4),
                      topRight:
                          proposal.againstPercentage == 0 &&
                                  proposal.abstainPercentage == 0
                              ? const Radius.circular(4)
                              : Radius.zero,
                      bottomRight:
                          proposal.againstPercentage == 0 &&
                                  proposal.abstainPercentage == 0
                              ? const Radius.circular(4)
                              : Radius.zero,
                    ),
                  ),
                ),
                Container(
                  height: 8,
                  width: proposal.againstPercentage * 3,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        proposal.forPercentage == 0
                            ? BorderRadius.only(
                              topLeft: const Radius.circular(4),
                              bottomLeft: const Radius.circular(4),
                              topRight:
                                  proposal.abstainPercentage == 0
                                      ? const Radius.circular(4)
                                      : Radius.zero,
                              bottomRight:
                                  proposal.abstainPercentage == 0
                                      ? const Radius.circular(4)
                                      : Radius.zero,
                            )
                            : null,
                  ),
                ),
                Container(
                  height: 8,
                  width: proposal.abstainPercentage * 3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        proposal.forPercentage == 0 &&
                                proposal.againstPercentage == 0
                            ? BorderRadius.circular(4)
                            : BorderRadius.only(
                              topRight: const Radius.circular(4),
                              bottomRight: const Radius.circular(4),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildVoteDetailItem(
              'For',
              proposal.votingPowerFor,
              proposal.forPercentage,
              Colors.green,
            ),
            _buildVoteDetailItem(
              'Against',
              proposal.votingPowerAgainst,
              proposal.againstPercentage,
              Colors.red,
            ),
            _buildVoteDetailItem(
              'Abstain',
              proposal.votingPowerAbstain,
              proposal.abstainPercentage,
              Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoteDetailItem(
    String label,
    double power,
    double percentage,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${_formatNumber(power)} (${percentage.toStringAsFixed(1)}%)',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String label, DateTime time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2 * 255),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor, width: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[300])),
          const Spacer(),
          Text(
            '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteItem(Vote vote) {
    Color voteColor;
    String voteText;

    switch (vote.voteType) {
      case VoteType.yes:
        voteColor = Colors.green;
        voteText = 'Yes';
        break;
      case VoteType.no:
        voteColor = Colors.red;
        voteText = 'No';
        break;
      case VoteType.abstain:
        voteColor = Colors.grey;
        voteText = 'Abstain';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(vote.voterId, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: voteColor.withValues(alpha: 0.2 * 255),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              voteText,
              style: TextStyle(
                color: voteColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${_formatNumber(vote.votingPower)} LCN',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showVoteDialog(BuildContext context, Proposal proposal) {
    VoteType selectedVote = VoteType.yes;
    double votingPower = _userVotingPower;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: AppTheme.cardColor,
                title: Text('Vote on ${proposal.title}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select your vote:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildVoteOption(
                          context,
                          VoteType.yes,
                          selectedVote,
                          Colors.green,
                          'Yes',
                          () {
                            setState(() {
                              selectedVote = VoteType.yes;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildVoteOption(
                          context,
                          VoteType.no,
                          selectedVote,
                          Colors.red,
                          'No',
                          () {
                            setState(() {
                              selectedVote = VoteType.no;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildVoteOption(
                          context,
                          VoteType.abstain,
                          selectedVote,
                          Colors.grey,
                          'Abstain',
                          () {
                            setState(() {
                              selectedVote = VoteType.abstain;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Voting Power:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Available: ${_formatNumber(_userVotingPower)} LCN'),
                    const SizedBox(height: 8),
                    Slider(
                      value: votingPower,
                      min: 0,
                      max: _userVotingPower,
                      divisions: 10,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.dividerColor,
                      label: _formatNumber(votingPower),
                      onChanged: (value) {
                        setState(() {
                          votingPower = value;
                        });
                      },
                    ),
                    Center(
                      child: Text(
                        '${_formatNumber(votingPower)} LCN',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        votingPower > 0
                            ? () {
                              Navigator.pop(context);
                              _submitVote(
                                context,
                                proposal,
                                selectedVote,
                                votingPower,
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.5 * 255,
                      ),
                    ),
                    child: const Text('Submit Vote'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildVoteOption(
    BuildContext context,
    VoteType voteType,
    VoteType selectedVote,
    Color color,
    String label,
    VoidCallback onTap,
  ) {
    final isSelected = voteType == selectedVote;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? color.withValues(alpha: 0.2 * 255)
                    : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppTheme.dividerColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitVote(
    BuildContext context,
    Proposal proposal,
    VoteType voteType,
    double votingPower,
  ) {
    // In a real app, this would call the blockchain to submit the vote
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vote submitted successfully for ${proposal.title}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _executeProposal(BuildContext context, Proposal proposal) {
    // In a real app, this would call the blockchain to execute the proposal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proposal ${proposal.title} executed successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showCreateProposalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationDaysController = TextEditingController(text: '7');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Create Proposal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter proposal title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter proposal description',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationDaysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (days)',
                      hintText: 'Enter voting duration in days',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Required Voting Power: 1,000,000 LCN',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Voting Power: ${_formatNumber(_userVotingPower)} LCN',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    Navigator.pop(context);
                    _createProposal(
                      context,
                      titleController.text,
                      descriptionController.text,
                      int.tryParse(durationDaysController.text) ?? 7,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void _createProposal(
    BuildContext context,
    String title,
    String description,
    int durationDays,
  ) {
    // In a real app, this would call the blockchain to create the proposal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proposal "$title" created successfully'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
